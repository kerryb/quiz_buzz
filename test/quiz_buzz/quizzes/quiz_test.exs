defmodule QuizBuzz.Quizzes.QuizTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Quizzes.{Quiz, Team}
  alias QuizBuzz.Factory

  describe "QuizBuzz.Quizzes.Quiz.new/1" do
    test "builds a new quiz with a generated ID" do
      generator = fn -> 42 end
      assert Quiz.new(generator) == %Quiz{id: 42, teams: []}
    end
  end

  describe "QuizBuzz.Quizzes.Quiz.add_team/2" do
    test "adds a new team with the supplied name" do
      quiz = Factory.new_quiz() |> Quiz.add_team("My team")
      assert [%Team{name: "My team"}] = quiz.teams
    end
  end
end
