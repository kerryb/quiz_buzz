defmodule QuizBuzz.Factory do
  alias QuizBuzz.Quizzes.{Player, Quiz, RandomIDGenerator, Team}

  def new_quiz do
    Quiz.new(&RandomIDGenerator.next/0)
  end

  def with_team(quiz, name) do
    %{quiz | teams: [Team.new(name)]}
  end

  def with_player(quiz, name) do
    %{quiz | players: [Player.new(name)]}
  end
end
