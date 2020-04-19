defmodule QuizBuzzWeb.QuizmasterLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest

  alias QuizBuzz.Registry

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizmasterLive, in the setup phase" do
    test "Displays the quiz ID", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/quizmaster")
      assert has_element?(view, ".qb-quiz-id", ~r/.{4}/)
    end

    test "Includes a link to the the quiz", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/quizmaster")
      assert has_element?(view, "a.qb-quiz-url", ~r(/quiz/.{4}))
    end

    test "shows each player's name", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/quizmaster")

      quiz_id =
        view |> element(".qb-quiz-id") |> render() |> String.replace(~r/.*>(.*)<.*/, "\\1")

      :ok = Registry.join_quiz(quiz_id, "Alice")
      :ok = Registry.join_quiz(quiz_id, "Bob")
      #  Re-render to catch the update from the pubsub message
      render(view)
      assert has_element?(view, ".qb-player", "Alice")
      assert has_element?(view, ".qb-player", "Bob")
    end

    test "shows each team", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/quizmaster")

      quiz_id =
        view |> element(".qb-quiz-id") |> render() |> String.replace(~r/.*>(.*)<.*/, "\\1")

      :ok = Registry.add_team(quiz_id, "Team one")
      :ok = Registry.add_team(quiz_id, "Team two")
      #  Re-render to catch the update from the pubsub message
      render(view)
      assert has_element?(view, ".qb-team", "Team one")
      assert has_element?(view, ".qb-team", "Team two")
    end

    test "show the players in each team", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/quizmaster")

      quiz_id =
        view |> element(".qb-quiz-id") |> render() |> String.replace(~r/.*>(.*)<.*/, "\\1")

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
