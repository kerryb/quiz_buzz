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
      bob_smith = Player.new("Bob Smith")
      existing_team = "Existing team" |> Team.new() |> with_player(bob_smith)

      quiz =
        new_quiz()
        |> with_player(jane_doe)
        |> with_team(existing_team)

      {:ok, quiz: quiz}
    end

    test "adds a new unaffiliated player with the supplied name, returning quiz and player", %{
      quiz: quiz
    } do
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

    test "rejects duplicate names within teams", %{quiz: quiz} do
      assert {:error, _} = quiz |> Setup.join_quiz("Bob Smith")
    end

    test "fails unless the quiz is in the setup state", %{quiz: quiz} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = quiz |> Setup.join_quiz("Joe Bloggs")
    end
  end

  describe "QuizBuzz.Quizzes.Setup.join_team/2" do
    setup do
      jane_doe = Player.new("Jane Doe")
      bob_smith = Player.new("Bob Smith")
      existing_team = "Existing team" |> Team.new() |> with_player(bob_smith)
      another_team = Team.new("Another team")

      quiz =
        new_quiz()
        |> with_player(jane_doe)
        |> with_team(existing_team)
        |> with_team(another_team)

      {:ok, quiz: quiz, existing_team: existing_team, player: jane_doe}
    end

    test "adds the player to the team", %{
      quiz: quiz,
      existing_team: existing_team,
      player: player
    } do
      {:ok, quiz} = quiz |> Setup.join_team(existing_team, player)
      team = quiz.teams |> Enum.find(&(&1.name == existing_team.name))
      assert [player, _] = team.players
    end

    test "removes the player from  the unaffiliated list", %{
      quiz: quiz,
      existing_team: existing_team,
      player: player
    } do
      {:ok, quiz} = quiz |> Setup.join_team(existing_team, player)
      assert quiz.players == []
    end

    test "fails unless the quiz is in the setup state", %{
      quiz: quiz,
      existing_team: existing_team,
      player: player
    } do
      quiz = %{quiz | state: :active}
      assert {:error, _} = quiz |> Setup.join_team(existing_team, player)
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
