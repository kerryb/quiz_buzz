defmodule QuizBuzz.Core do
  @moduledoc """
  Entry point for the Core context.
  """

  alias QuizBuzz.Core.Setup

  defdelegate add_team(quiz, name), to: Setup
  defdelegate join_quiz(quiz, name), to: Setup
  defdelegate join_team(quiz, team, player), to: Setup
end
