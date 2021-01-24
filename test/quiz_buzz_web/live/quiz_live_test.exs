defmodule QuizBuzzWeb.QuizLiveTest do
  use QuizBuzzWeb.ConnCase

  import ExUnit.CaptureLog
  import Phoenix.LiveViewTest

  alias QuizBuzz.Registry
  alias QuizBuzzWeb.QuizLive
  alias QuizBuzzWeb.QuizLive.InvalidQuizIDError

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizLive" do
    test "logs and ignores unexpected events and messages", %{conn: conn} do
      {:ok, quiz} = Registry.new_quiz()
      {:ok, view, _html} = live(conn, "/quiz/#{quiz.id}")
      view |> element("form") |> render_change(%{"player_name" => "Alice"})
      view |> element("form") |> render_submit()

      assert capture_log(fn -> render_change(view, "foo", %{"bar" => "baz"}) end) =~
               ~r/Received unexpected event: "foo" with params %{"bar" => "baz"}/

      assert capture_log(fn ->
               send(view.pid, "foo")
               render(view)
             end) =~
               ~r/Received unexpected message: "foo"/

      assert render(view) =~ "Alice"
    end
  end

  describe "QuizBuzzWeb.QuizLive, in the joining phase" do
    setup %{conn: conn} do
      {:ok, quiz} = Registry.new_quiz()
      :ok = Registry.join_quiz(quiz.id, "Alice")
      {:ok, view, _html} = live(conn, "/quiz/#{quiz.id}")
      {:ok, view: view, quiz_id: quiz.id}
    end

    test "404s if the quiz does not exist", %{conn: conn} do
      assert_raise InvalidQuizIDError, fn -> live(conn, "/quiz/XXXX") end
    end

    test "Ignores the case of the supplied ID", %{conn: conn, quiz_id: quiz_id} do
      assert {:ok, _view, _html} = live(conn, "/quiz/#{String.downcase(quiz_id)}")
    end

    test "prompts for the player's name, with the join button initially disabled, if they have not yet joined",
         %{view: view} do
      assert has_element?(view, "input[name=player_name]")
      assert has_element?(view, "button[disabled=disabled]")
    end

    test "remains in the same state despite receiving quiz updates", %{
      view: view,
      quiz_id: quiz_id
    } do
      :ok = Registry.join_quiz(quiz_id, "Bob")
      #  Re-render to catch the update from the pubsub message
      render(view)
      assert has_element?(view, "input[name=player_name]")
    end

    test "disables the join button and shows a flash if the name is already taken", %{view: view} do
      view |> element("form") |> render_change(%{"player_name" => "Alice"})
      assert has_element?(view, "button[disabled=disabled]")
      assert has_element?(view, ".alert-danger", "That name has already been taken")
    end

    test "disables the join button and shows a flash if the name is reset to blank", %{view: view} do
      view |> element("form") |> render_change(%{"player_name" => "Bob"})
      view |> element("form") |> render_change(%{"player_name" => ""})
      assert has_element?(view, "button[disabled=disabled]")
      assert has_element?(view, ".alert-danger", "Name must not be blank")
    end

    test "enables the join button and removes the flash if the name is valid", %{view: view} do
      view |> element("form") |> render_change(%{"player_name" => "Alice"})
      view |> element("form") |> render_change(%{"player_name" => "Bob"})
      assert has_element?(view, "button:not([disabled])")
      refute has_element?(view, ".alert-danger", ~r/./)
    end
  end

  describe "QuizBuzzWeb.QuizLive, in the setup phase" do
    setup %{conn: conn} do
      {:ok, quiz} = Registry.new_quiz()
      :ok = Registry.join_quiz(quiz.id, "Alice")
      :ok = Registry.add_team(quiz.id, "Team one")
      :ok = Registry.add_team(quiz.id, "Team two")
      {:ok, view, _html} = live(conn, "/quiz/#{quiz.id}")
      view |> element("form") |> render_change(%{"player_name" => "Bob"})
      view |> element("form") |> render_submit()
      #  Re-render to catch the update from the pubsub messages
      render(view)
      {:ok, view: view, quiz_id: quiz.id, secret_id: quiz.secret_id}
    end

    test "shows a message after joining until the quiz starts", %{view: view} do
      assert render(view) =~ ~r/The quiz has not yet started/
    end

    test "shows each player's name, with 'me' highlighted", %{view: view} do
      assert has_element?(view, ".qb-player", "Alice")
      assert has_element?(view, ".qb-player.qb-me", "Bob")
    end

    test "shows each team", %{view: view} do
      assert has_element?(view, ".qb-team", "Team one")
      assert has_element?(view, ".qb-team", "Team two")
    end

    test "moves the player's name to a team when they join one", %{view: view} do
      view |> element("button", "Join Team one") |> render_click()
      #  Re-render to catch the update from the pubsub message
      render(view)
      assert has_element?(view, ".qb-team-player.qb-me", "Bob")
      refute has_element?(view, ".qb-player", "Bob")
    end
  end

  describe "QuizBuzzWeb.QuizLive, in the active phase" do
    setup %{conn: conn} do
      {:ok, quiz} = Registry.new_quiz()
      :ok = Registry.join_quiz(quiz.id, "Alice")
      :ok = Registry.join_quiz(quiz.id, "Carol")
      :ok = Registry.add_team(quiz.id, "Team one")
      :ok = Registry.add_team(quiz.id, "Team two")
      :ok = Registry.join_team(quiz.id, "Team one", "Carol")
      {:ok, view, _html} = live(conn, "/quiz/#{quiz.id}")
      view |> element("form") |> render_change(%{"player_name" => "Bob"})
      view |> element("form") |> render_submit()
      view |> element("button", "Join Team one") |> render_click()
      :ok = Registry.start_quiz(quiz.id)
      #  Re-render to catch the update from the pubsub messages
      render(view)
      {:ok, view: view, quiz_id: quiz.id}
    end

    test "no longer shows the 'not started' message", %{view: view} do
      refute render(view) =~ ~r/The quiz has not yet started/
    end

    test "shows each individual player as a team", %{view: view} do
      assert has_element?(view, ".qb-team", "Alice")
    end

    test "shows each team, and its players (with the current player highlighted)", %{view: view} do
      assert has_element?(view, ".qb-team", "Team one")
      assert has_element?(view, ".qb-team", "Team two")
      assert has_element?(view, ".qb-team-player", "Carol")
      assert has_element?(view, ".qb-team-player.qb-me", "Bob")
    end

    test "indicates when a team player buzzes using the buzz button", %{view: view} do
      view |> element("button", "Buzz") |> render_click()
      assert has_element?(view, ".qb-scoreboard.qb-buzzed")
      assert has_element?(view, ".qb-team.qb-buzzed", "Team one")
      assert has_element?(view, ".qb-team-player.qb-buzzed", "Bob")
    end

    test "indicates when a team player buzzes using the space bar", %{view: view} do
      view |> element("button", "Buzz") |> render_keyup(%{code: "Space"})
      assert has_element?(view, ".qb-scoreboard.qb-buzzed")
      assert has_element?(view, ".qb-team.qb-buzzed", "Team one")
      assert has_element?(view, ".qb-team-player.qb-buzzed", "Bob")
    end

    test "ignores other keyups", %{view: view} do
      view |> element("button", "Buzz") |> render_keyup(%{code: "AltLeft"})
      refute has_element?(view, ".qb-scoreboard.qb-buzzed")
    end

    test "indicates when an individual player buzzes", %{view: view, quiz_id: quiz_id} do
      :ok = Registry.buzz(quiz_id, "Alice")
      assert has_element?(view, ".qb-team.qb-buzzed", "Alice")
    end
  end

  describe "QuizBuzzWeb.QuizLive, on termination" do
    setup %{conn: conn} do
      {:ok, quiz} = Registry.new_quiz()
      {:ok, view, _html} = live(conn, "/quiz/#{quiz.id}")
      view |> element("form") |> render_change(%{"player_name" => "Bob"})
      view |> element("form") |> render_submit()
      {:ok, view: view, quiz: quiz}
    end

    test "leaves the quiz", %{quiz: quiz} do
      QuizLive.terminate(:normal, %{assigns: %{quiz: quiz, player_name: "Bob"}})
      {:ok, quiz} = Registry.quiz_from_id(quiz.id)

      assert quiz.players == []
    end
  end
end
