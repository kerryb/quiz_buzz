defmodule QuizBuzzWeb.QuizLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest

  alias QuizBuzz.Registry
  alias QuizBuzzWeb.QuizLive.InvalidQuizIDError

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizLive" do
    test "404s if the quiz does not exist", %{conn: conn} do
      assert_raise InvalidQuizIDError, fn -> live(conn, "/quiz/XXXX") end
    end

    test "prompts for the player's name, with the join button initially disabled, if they have not yet joined",
         %{conn: conn} do
      {:ok, quiz_id} = Registry.new_quiz()
      {:ok, view, _html} = live(conn, "/quiz/#{quiz_id}")
      assert has_element?(view, "input[name=name]")
      assert has_element?(view, "button[disabled=disabled]")
    end

    test "disables the join button and shows a flash if the name is already taken", %{conn: conn} do
      {:ok, quiz_id} = Registry.new_quiz()
      :ok = Registry.join_quiz(quiz_id, "Alice")
      {:ok, view, _html} = live(conn, "/quiz/#{quiz_id}")
      view |> element("form") |> render_change(%{"name" => "Alice"})
      assert has_element?(view, "button[disabled=disabled]")
      assert has_element?(view, ".alert-danger", "That name has already been taken")
    end

    test "disables the join button and shows a flash if the name is reset to blank", %{conn: conn} do
      {:ok, quiz_id} = Registry.new_quiz()
      {:ok, view, _html} = live(conn, "/quiz/#{quiz_id}")
      view |> element("form") |> render_change(%{"name" => "Alice"})
      view |> element("form") |> render_change(%{"name" => ""})
      assert has_element?(view, "button[disabled=disabled]")
      assert has_element?(view, ".alert-danger", "Name must not be blank")
    end

    test "enables the join button and removes the flash if the name is valid", %{conn: conn} do
      {:ok, quiz_id} = Registry.new_quiz()
      :ok = Registry.join_quiz(quiz_id, "Alice")
      {:ok, view, _html} = live(conn, "/quiz/#{quiz_id}")
      view |> element("form") |> render_change(%{"name" => "Alice"})
      view |> element("form") |> render_change(%{"name" => "Bob"})
      assert has_element?(view, "button:not([disabled])")
      refute has_element?(view, ".alert-danger", ~r/./)
    end

    test "shows a message after joining until the quiz starts", %{conn: conn} do
      {:ok, quiz_id} = Registry.new_quiz()
      {:ok, view, _html} = live(conn, "/quiz/#{quiz_id}")
      view |> element("form") |> render_change(%{"name" => "Alice"})
      html = view |> element("form") |> render_submit()
      assert html =~ ~r/The quiz has not yet started/
    end

    test "shows each player's name", %{conn: conn} do
      {:ok, quiz_id} = Registry.new_quiz()
      :ok = Registry.join_quiz(quiz_id, "Alice")
      {:ok, view, _html} = live(conn, "/quiz/#{quiz_id}")
      view |> element("form") |> render_change(%{"name" => "Bob"})
      view |> element("form") |> render_submit()
      #  Re-render to catch the update from the pubsub message
      render(view)
      assert has_element?(view, ".qb-player", "Alice")
      assert has_element?(view, ".qb-player", "Bob")
    end

    test "shows each team", %{conn: conn} do
      {:ok, quiz_id} = Registry.new_quiz()
      :ok = Registry.add_team(quiz_id, "Team one")
      :ok = Registry.add_team(quiz_id, "Team two")
      {:ok, view, _html} = live(conn, "/quiz/#{quiz_id}")
      view |> element("form") |> render_change(%{"name" => "Bob"})
      view |> element("form") |> render_submit()
      assert has_element?(view, ".qb-team", "Team one")
      assert has_element?(view, ".qb-team", "Team two")
    end
  end
end
