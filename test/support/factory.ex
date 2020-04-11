# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule QuizBuzz.Factory do
  @moduledoc """
  Test helpers to build quizzes and associated structs.
  """

  alias QuizBuzz.Quizzes.{Quiz, RandomIDGenerator}

  def new_quiz do
    Quiz.new(&RandomIDGenerator.next/0)
  end

  def with_team(quiz, team) do
    %{quiz | teams: [team | quiz.teams]}
  end

  def with_player(quiz_or_team, player) do
    %{quiz_or_team | players: [player | quiz_or_team.players]}
  end
end
