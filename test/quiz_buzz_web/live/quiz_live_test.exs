defmodule QuizBuzzWeb.QuizLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest

  alias QuizBuzz.Registry
  alias QuizBuzzWeb.QuizLive.InvalidQuizdIdError

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizLive" do
    test "404s if the quiz does not exist", %{conn: conn} do
      assert_raise InvalidQuizdIdError, fn -> live(conn, "/quiz/XXXX") end
    end

    test "prompts for the player's name, with the join button initially disabled, if they have not yet joined",
         %{conn: conn} do
      {:ok, id} = Registry.new_quiz()
      {:ok, _view, html} = live(conn, "/quiz/#{id}")
      {:ok, dom} = Floki.parse_document(html)
      [{_, attributes, _}] = Floki.find(dom, "input")
      assert {"name", "name"} in attributes
      assert Floki.attribute(dom, "button", "disabled") == ["disabled"]
    end

    test "disables the join button and shows a flash if the name is already taken", %{conn: conn} do
      {:ok, id} = Registry.new_quiz()
      :ok = Registry.join_quiz(id, "Alice")
      {:ok, view, _html} = live(conn, "/quiz/#{id}")
      html = render_change(view, "form-change", %{"name" => "Alice"})
      {:ok, dom} = Floki.parse_document(html)
      assert Floki.attribute(dom, "button", "disabled") == ["disabled"]
      [{_, _, ["That name has already been taken"]}] = Floki.find(dom, ".alert-danger")
    end

    test "disables the join button and shows a flash if the name is reset to blank", %{conn: conn} do
      {:ok, id} = Registry.new_quiz()
      {:ok, view, _html} = live(conn, "/quiz/#{id}")
      render_change(view, "form-change", %{"name" => "Alice"})
      html = render_change(view, "form-change", %{"name" => ""})
      {:ok, dom} = Floki.parse_document(html)
      assert Floki.attribute(dom, "button", "disabled") == ["disabled"]
      [{_, _, ["Name must not be blank"]}] = Floki.find(dom, ".alert-danger")
    end

    test "enables the join button and removes the flash if the name is valid", %{conn: conn} do
      {:ok, id} = Registry.new_quiz()
      :ok = Registry.join_quiz(id, "Alice")
      {:ok, view, _html} = live(conn, "/quiz/#{id}")
      render_change(view, "form-change", %{"name" => "Alice"})
      html = render_change(view, "form-change", %{"name" => "Bob"})
      {:ok, dom} = Floki.parse_document(html)
      assert Floki.attribute(dom, "button", "disabled") == []
      [{_, _, []}] = Floki.find(dom, ".alert-danger")
    end

    test "shows a message after joining until the quiz starts", %{conn: conn} do
      {:ok, id} = Registry.new_quiz()
      {:ok, view, _html} = live(conn, "/quiz/#{id}")
      render_change(view, "form-change", %{"name" => "Alice"})
      html = render_click(view, "join-quiz")
      assert html =~ ~r/The quiz has not yet started/
    end

    test "shows each player's name", %{conn: conn} do
      {:ok, id} = Registry.new_quiz()
      :ok = Registry.join_quiz(id, "Alice")
      {:ok, view, _html} = live(conn, "/quiz/#{id}")
      render_change(view, "form-change", %{"name" => "Bob"})
      render_click(view, "join-quiz")
      #  Re-render to catch the update from the pubsub message
      html = render(view)
      {:ok, dom} = Floki.parse_document(html)
      [{_, _, ["Bob"]}, {_, _, ["Alice"]}] = Floki.find(dom, ".qb-player")
    end
  end
end
