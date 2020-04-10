defmodule QuizBuzz.Quizzes do
  @moduledoc """
  Entry point for the Quizzes context.
  """

  alias QuizBuzz.Quizzes.Setup

  defdelegate add_team(quiz, name), to: Setup
  defdelegate join_quiz(quiz, name), to: Setup
  defdelegate join_team(quiz, team, player), to: Setup
end
