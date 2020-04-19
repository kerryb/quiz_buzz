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

      {:ok, view: view, quiz_id: quiz_id}
    end

    test "Displays the quiz ID", %{view: view, quiz_id: quiz_id} do
      assert has_element?(view, ".qb-quiz-id", quiz_id)
    end

    test "Includes a link to the the quiz", %{view: view, quiz_id: quiz_id} do
      assert has_element?(view, "a.qb-quiz-url", quiz_id)
    end

    test "shows each player's name", %{view: view, quiz_id: quiz_id} do
      :ok = Registry.join_quiz(quiz_id, "Alice")
      :ok = Registry.join_quiz(quiz_id, "Bob")
      #  Re-render to catch the update from the pubsub message
      render(view)
      assert has_element?(view, ".qb-player", "Alice")
      assert has_element?(view, ".qb-player", "Bob")
    end

    test "shows each team", %{view: view, quiz_id: quiz_id} do
      :ok = Registry.add_team(quiz_id, "Team one")
      :ok = Registry.add_team(quiz_id, "Team two")
      #  Re-render to catch the update from the pubsub message
      render(view)
      assert has_element?(view, ".qb-team", "Team one")
      assert has_element?(view, ".qb-team", "Team two")
    end

    test "show the players in each team", %{view: view, quiz_id: quiz_id} do
      :ok = Registry.join_quiz(quiz_id, "Alice")
      :ok = Registry.add_team(quiz_id, "Team one")
      :ok = Registry.join_team(quiz_id, "Team one", "Alice")
      #  Re-render to catch the update from the pubsub message
      render(view)
      assert has_element?(view, ".qb-team-player", "Alice")
      refute has_element?(view, ".qb-player", "Alice")
    end
  end
end
