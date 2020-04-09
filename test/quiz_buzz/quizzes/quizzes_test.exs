defmodule QuizBuzz.QuizzesTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.{Factory, Quizzes}
  alias QuizBuzz.Quizzes.{Player, Team}

  describe "QuizBuzz.Quizzes.add_team/2" do
    test "adds a new team with the supplied name" do
      quiz =
        Factory.new_quiz() |> Factory.with_team("Existing team") |> Quizzes.add_team("My team")

      assert [%Team{name: "My team"}, %Team{name: "Existing team"}] = quiz.teams
    end
  end

  describe "QuizBuzz.Quizzes.join_quiz/2" do
    test "adds a new unaffiliated player with the supplied name" do
      quiz =
        Factory.new_quiz() |> Factory.with_player("Jane Doe") |> Quizzes.join_quiz("Joe Bloggs")

      assert [%Player{name: "Joe Bloggs"}, %Player{name: "Jane Doe"}] = quiz.players
    end
  end

  describe "QuizBuzz.Quizzes.join_team/2" do
    setup do
      quiz =
        Factory.new_quiz()
        |> Factory.with_team("Existing team", ["Jane Doe"])
        |> Factory.with_player("Joe Bloggs")

      {:ok, quiz: quiz}
    end

    test "adds the player to the team", %{quiz: %{teams: [team], players: [player]} = quiz} do
      %{teams: [team]} = quiz |> Quizzes.join_team(team, player)
      assert [%Player{name: "Joe Bloggs"}, %Player{name: "Jane Doe"}] = team.players
    end

    test "removes the player from  the unaffiliated list", %{
      quiz: %{teams: [team], players: [player]} = quiz
    } do
      %{players: players} = quiz |> Quizzes.join_team(team, player)
      assert players == []
    end
  end
end
