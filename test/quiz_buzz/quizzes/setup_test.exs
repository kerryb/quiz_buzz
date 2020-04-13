# credo:disable-for-this-file Credo.Check.Readability.SinglePipe

defmodule QuizBuzz.Quizzes.SetupTest do
  use ExUnit.Case, async: true

  import QuizBuzz.Factory
  alias QuizBuzz.Quizzes.{Player, Setup, Team}

  describe "QuizBuzz.Quizzes.Setup.add_team/2" do
    setup do
      existing_team = Team.new("Existing team")
      quiz = new_quiz() |> with_team(existing_team)
      {:ok, quiz: quiz}
    end

    test "adds a new team with the supplied name", %{quiz: quiz} do
      {:ok, quiz} = quiz |> Setup.add_team("My team")
      assert [%Team{name: "My team"}, %Team{name: "Existing team"}] = quiz.teams
    end

    test "rejects blank names", %{quiz: quiz} do
      assert {:error, _} = quiz |> Setup.add_team("")
    end

    test "rejects duplicate names", %{quiz: quiz} do
      assert {:error, _} = quiz |> Setup.add_team("Existing team")
    end

    test "fails unless the quiz is in the setup state", %{quiz: quiz} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = quiz |> Setup.add_team("My team")
    end
  end

  describe "QuizBuzz.Quizzes.Setup.join_quiz/2" do
    setup do
      jane_doe = Player.new("Jane Doe")
      existing_team = Team.new("Existing team")

      quiz =
        new_quiz()
        |> with_player(jane_doe)
        |> with_team(existing_team)

      {:ok, quiz: quiz}
    end

    test "adds a new player with the supplied name, returning quiz and player", %{quiz: quiz} do
      {:ok, quiz, player} = quiz |> Setup.join_quiz("Joe Bloggs")
      assert player.name == "Joe Bloggs"
      assert [^player, %{name: "Jane Doe"}] = quiz.players
    end

    test "rejects blank names", %{quiz: quiz} do
      assert {:error, _} = quiz |> Setup.join_quiz("")
    end

    test "rejects duplicate names", %{quiz: quiz} do
      assert {:error, _} = quiz |> Setup.join_quiz("Jane Doe")
    end

    test "fails unless the quiz is in the setup state", %{quiz: quiz} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = quiz |> Setup.join_quiz("Joe Bloggs")
    end
  end

  describe "QuizBuzz.Quizzes.Setup.join_team/2" do
    setup do
      jane_doe = Player.new("Jane Doe")
      team = Team.new("A team")

      quiz =
        new_quiz()
        |> with_player(jane_doe)
        |> with_team(team)

      {:ok, quiz: quiz, team: team, player: jane_doe}
    end

    test "sets the player's team", %{quiz: quiz, team: team, player: player} do
      {:ok, quiz} = quiz |> Setup.join_team(team, player)
      [player] = quiz.players
      assert player.team == team
    end

    test "fails unless the quiz is in the setup state", %{quiz: quiz, team: team, player: player} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = quiz |> Setup.join_team(team, player)
    end
  end

  describe "QuizBuzz.Quizzes.Setup.start/1" do
    setup do
      {:ok, quiz: new_quiz()}
    end

    test "sets the state to :active", %{quiz: quiz} do
      {:ok, quiz} = quiz |> Setup.start()
      assert quiz.state == :active
    end

    test "fails unless the quiz is in the setup state", %{quiz: quiz} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = quiz |> Setup.start()
    end
  end
end
