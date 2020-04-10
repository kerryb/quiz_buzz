defmodule QuizBuzz.Quizzes.QuizTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Quizzes.Quiz

  describe "QuizBuzz.Quizzes.Quiz.new/1" do
    test "builds a new quiz with a generated ID" do
      generator = fn -> 42 end
      assert Quiz.new(generator) == %Quiz{id: 42, teams: [], players: [], state: :setup}
    end
  end
end
