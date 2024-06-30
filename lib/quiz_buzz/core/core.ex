defmodule QuizBuzz.Core do
  @moduledoc """
  Entry point for the Core context.
  """

  alias QuizBuzz.Core.Play
  alias QuizBuzz.Core.Setup

  defdelegate new_quiz, to: Setup
  defdelegate add_team(quiz, name), to: Setup
  defdelegate validate_player_name(quiz, name), to: Setup
  defdelegate join_quiz(quiz, name), to: Setup
  defdelegate leave_quiz(quiz, name), to: Setup
  defdelegate join_team(quiz, team, player), to: Setup
  defdelegate start(quiz), to: Setup

  defdelegate buzz(quiz, player), to: Play
  defdelegate reset_buzzers(quiz), to: Play
end
