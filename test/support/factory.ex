# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule QuizBuzz.Factory do
  @moduledoc """
  Test helpers to build quizzes and associated structs.
  """

  alias QuizBuzz.Core.RandomIDGenerator
  alias QuizBuzz.Schema.Quiz

  def new_quiz do
    Quiz.new(&RandomIDGenerator.next/0)
  end

  def active_quiz do
    %{new_quiz() | state: :active}
  end

  def buzzed_quiz do
    %{new_quiz() | state: :buzzed}
  end

  def with_team(quiz, team) do
    %{quiz | teams: [team | quiz.teams]}
  end

  def with_player(quiz, player) do
    %{quiz | players: [player | quiz.players]}
  end
end
