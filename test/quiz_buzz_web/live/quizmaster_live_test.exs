defmodule QuizBuzzWeb.QuizmasterLiveTest do
  use QuizBuzzWeb.ConnCase

  import ExUnit.CaptureLog
  import Phoenix.LiveViewTest

  alias QuizBuzz.Registry

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizmasterLive" do
    test "logs and ignores unexpected events and messages", %{conn: conn} do
      {view, quiz_id} = start_new_quiz(conn)

      assert capture_log(fn -> render_change(view, "foo", %{"bar" => "baz"}) end) =~
               ~r/Received unexpected event: "foo" with params %{"bar" => "baz"}/

      assert capture_log(fn ->
               send(view.pid, "foo")
               render(view)
             end) =~
               ~r/Received unexpected message: "foo"/

      assert render(view) =~ quiz_id
    end
  end

  describe "QuizBuzzWeb.QuizmasterLive, in the setup phase" do
    setup %{conn: conn} do
      {view, quiz_id} = start_new_quiz(conn)
      :ok = Registry.add_team(quiz_id, "Team one")
      :ok = Registry.add_team(quiz_id, "Team two")
      :ok = Registry.join_quiz(quiz_id, "Alice")
      :ok = Registry.join_quiz(quiz_id, "Bob")
      :ok = Registry.join_team(quiz_id, "Team one", "Alice")
      #  Re-render to catch the update from the pubsub messages
      render(view)
      {:ok, view: view, quiz_id: quiz_id}
    end

    test "Displays the quiz ID", %{view: view, quiz_id: quiz_id} do
      assert has_element?(view, ".qb-quiz-id", quiz_id)
    end

    test "Includes a link to the the quiz", %{view: view, quiz_id: quiz_id} do
      assert has_element?(view, "a.qb-quiz-url", quiz_id)
    end

    test "shows each individual player's name", %{view: view} do
      assert has_element?(view, ".qb-player", "Bob")
    end

    test "shows each team", %{view: view} do
      assert has_element?(view, ".qb-team", "Team one")
      assert has_element?(view, ".qb-team", "Team two")
    end

    test "allows teams to be added", %{view: view} do
      view |> element("form") |> render_change(%{"team_name" => "Team three"})
      view |> element("form") |> render_submit()
      assert has_element?(view, ".qb-team", "Team three")
    end

    test "displays the error message if adding a team fails", %{view: view, quiz_id: quiz_id} do
      view |> element("form") |> render_change(%{"team_name" => "Team three"})
      Registry.add_team(quiz_id, "Team three")
      view |> element("form") |> render_submit()
      assert has_element?(view, ".alert-danger", "That name has already been taken")
    end

    test "disables the add team button if the name is blank", %{view: view} do
      view |> element("form") |> render_change(%{"team_name" => ""})
      assert has_element?(view, "button[disabled=disabled]", "Add team")
    end

    test "disables the add team button if the name is already taken", %{view: view} do
      view |> element("form") |> render_change(%{"team_name" => "Team one"})
      assert has_element?(view, "button[disabled=disabled]", "Add team")
    end

    test "show the players in each team", %{view: view} do
      assert has_element?(view, ".qb-team-player", "Alice")
    end

    test "allows the quiz to be started", %{view: view} do
      assert render(view) =~ ~r/The quiz has not yet started/
      view |> element("button", "Start quiz") |> render_click()
      #  Re-render to catch the update from the pubsub message
      html = render(view)
      refute html =~ ~r/The quiz has not yet started/
    end
  end

  describe "QuizBuzzWeb.QuizmasterLive, in the active phase" do
    setup %{conn: conn} do
      {view, quiz_id} = start_new_quiz(conn)
      :ok = Registry.join_quiz(quiz_id, "Alice")
      view |> element("button", "Start quiz") |> render_click()
      {:ok, view: view, quiz_id: quiz_id}
    end

    test "indicates when a player buzzes", %{view: view, quiz_id: quiz_id} do
      :ok = Registry.buzz(quiz_id, "Alice")
      assert has_element?(view, ".qb-team.qb-buzzed", "Alice")
    end

    test "allows buzzers to be reset", %{view: view, quiz_id: quiz_id} do
      :ok = Registry.buzz(quiz_id, "Alice")
      #  Re-render to catch the update from the pubsub messages
      render(view)
      view |> element("button", "Reset buzzers") |> render_click()
      refute has_element?(view, ".qb-buzzed")
    end
  end

  defp start_new_quiz(conn) do
    {:error, {:redirect, %{to: url}}} = live(conn, "/quizmaster")
    {:ok, view, _html} = live(conn, url)
    quiz_id = view |> element(".qb-quiz-id") |> render() |> String.replace(~r/.*>(.*)<.*/, "\\1")
    {view, quiz_id}
  end
end
