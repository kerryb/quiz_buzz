# credo:disable-for-this-file Credo.Check.Readability.SinglePipe
defmodule QuizBuzz.Core.SetupTest do
  use ExUnit.Case, async: true

  import QuizBuzz.Factory
  alias QuizBuzz.Core.{RandomIDGenerator, Setup}
  alias QuizBuzz.Schema.{Player, Team}

  describe "QuizBuzz.Core.Setup.new_quiz/0" do
    setup do
      RandomIDGenerator.start_link([])
      :ok
    end

    test "creates a quiz with a random ID" do
      {:ok, quiz_1} = Setup.new_quiz()
      {:ok, quiz_2} = Setup.new_quiz()
      refute quiz_1.id == quiz_2.id
    end
  end

  describe "QuizBuzz.Core.Setup.add_team/2" do
    setup do
      existing_team = Team.new("Existing team")
      quiz = new_quiz() |> with_team(existing_team)
      {:ok, quiz: quiz}
    end

    test "adds a new team with the supplied name", %{quiz: quiz} do
      {:ok, quiz} = Setup.add_team(quiz, "My team")
      assert [%Team{name: "My team"}, %Team{name: "Existing team"}] = quiz.teams
    end

    test "rejects blank names", %{quiz: quiz} do
      assert {:error, _} = Setup.add_team(quiz, "")
    end

    test "rejects duplicate names", %{quiz: quiz} do
      assert {:error, _} = Setup.add_team(quiz, "Existing team")
    end

    test "fails unless the quiz is in the setup state", %{quiz: quiz} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = Setup.add_team(quiz, "My team")
    end
  end

  describe "QuizBuzz.Core.Setup.validate_player_name/2" do
    setup do
      jane_doe = Player.new("Jane Doe")
      # credo:disable-for-next-line Credo.Check.Readability.SinglePipe
      quiz = new_quiz() |> with_player(jane_doe)
      {:ok, quiz: quiz}
    end

    test "rejects blank names", %{quiz: quiz} do
      assert {:error, "Name must not be blank"} = Setup.validate_player_name(quiz, "")
    end

    test "rejects duplicate names", %{quiz: quiz} do
      assert {:error, "That name has already been taken"} =
               Setup.validate_player_name(quiz, "Jane Doe")
    end

    test "accepts unique, non-blank names", %{quiz: quiz} do
      assert :ok = Setup.validate_player_name(quiz, "Joe Bloggs")
    end
  end

  describe "QuizBuzz.Core.Setup.join_quiz/2" do
    setup do
      jane_doe = Player.new("Jane Doe")
      existing_team = Team.new("Existing team")

      quiz =
        new_quiz()
        |> with_player(jane_doe)
        |> with_team(existing_team)

      {:ok, quiz: quiz}
    end

    test "adds a new player with the supplied name", %{quiz: quiz} do
      {:ok, quiz} = Setup.join_quiz(quiz, "Joe Bloggs")
      assert [%{name: "Joe Bloggs"}, %{name: "Jane Doe"}] = quiz.players
    end

    test "rejects blank names", %{quiz: quiz} do
      assert {:error, _} = Setup.join_quiz(quiz, "")
    end

    test "rejects duplicate names", %{quiz: quiz} do
      assert {:error, _} = Setup.join_quiz(quiz, "Jane Doe")
    end

    test "fails unless the quiz is in the setup state", %{quiz: quiz} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = Setup.join_quiz(quiz, "Joe Bloggs")
    end
  end

  describe "QuizBuzz.Core.Setup.leave_quiz/2" do
    setup do
      jane_doe = Player.new("Jane Doe")
      quiz = new_quiz() |> with_player(jane_doe)
      {:ok, quiz: quiz}
    end

    test "removes the player with the supplied name", %{quiz: quiz} do
      {:ok, quiz} = Setup.leave_quiz(quiz, "Jane Doe")
      assert [] = quiz.players
    end
  end

  describe "QuizBuzz.Core.Setup.join_team/3" do
    setup do
      jane_doe = Player.new("Jane Doe")
      team = Team.new("A team")

      quiz =
        new_quiz()
        |> with_player(jane_doe)
        |> with_team(team)

      {:ok, quiz: quiz, team: team, player: jane_doe}
    end

    test "sets the player's team", %{quiz: quiz} do
      {:ok, quiz} = Setup.join_team(quiz, "Jane Doe", "A team")
      [player] = quiz.players
      assert player.team.name == "A team"
    end

    test "fails unless the quiz is in the setup state", %{quiz: quiz} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = Setup.join_team(quiz, "Jane Doe", "A team")
    end
  end

  describe "QuizBuzz.Core.Setup.start/1" do
    setup do
      {:ok, quiz: new_quiz()}
    end

    test "sets the state to :active", %{quiz: quiz} do
      {:ok, quiz} = Setup.start(quiz)
      assert quiz.state == :active
    end

    test "fails unless the quiz is in the setup state", %{quiz: quiz} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = Setup.start(quiz)
    end
  end
end
