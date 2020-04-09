defmodule QuizBuzz.Quizzes.SetupTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Factory
  alias QuizBuzz.Quizzes.{Player, Setup, Team}

  describe "QuizBuzz.Quizzes.Setup.add_team/2" do
    setup do
      quiz = Factory.new_quiz() |> Factory.with_team("Existing team")
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
  end

  describe "QuizBuzz.Quizzes.Setup.join_quiz/2" do
    setup do
      quiz =
        Factory.new_quiz()
        |> Factory.with_player("Jane Doe")
        |> Factory.with_team("Existing team", ["Bob Smith"])

      {:ok, quiz: quiz}
    end

    test "adds a new unaffiliated player with the supplied name", %{quiz: quiz} do
      {:ok, quiz} = quiz |> Setup.join_quiz("Joe Bloggs")
      assert [%Player{name: "Joe Bloggs"}, %Player{name: "Jane Doe"}] = quiz.players
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
  end

  describe "QuizBuzz.Quizzes.Setup.join_team/2" do
    setup do
      quiz =
        Factory.new_quiz()
        |> Factory.with_team("Existing team", ["Jane Doe"])
        |> Factory.with_player("Joe Bloggs")

      {:ok, quiz: quiz}
    end

    test "adds the player to the team", %{quiz: %{teams: [team], players: [player]} = quiz} do
      {:ok, quiz} = quiz |> Setup.join_team(team, player)
      %{teams: [team]} = quiz
      assert [%Player{name: "Joe Bloggs"}, %Player{name: "Jane Doe"}] = team.players
    end

    test "removes the player from  the unaffiliated list", %{
      quiz: %{teams: [team], players: [player]} = quiz
    } do
      {:ok, quiz} = quiz |> Setup.join_team(team, player)
      %{players: players} = quiz
      assert players == []
    end
  end
end
