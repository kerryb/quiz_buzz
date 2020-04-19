defmodule QuizBuzzWeb.QuizmasterLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest

  alias QuizBuzz.Registry

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizmasterLive, in the setup phase" do
    setup %{conn: conn} do
      {:ok, view, _html} = live(conn, "/quizmaster")

      quiz_id =
        view |> element(".qb-quiz-id") |> render() |> String.replace(~r/.*>(.*)<.*/, "\\1")

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
end
