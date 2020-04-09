defmodule QuizBuzz.Factory do
  alias QuizBuzz.Quizzes.{Quiz, RandomIDGenerator}

  def new_quiz do
    Quiz.new(&RandomIDGenerator.next/0)
  end
end
