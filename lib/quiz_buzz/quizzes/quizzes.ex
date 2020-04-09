defmodule QuizBuzz.Quizzes do
  alias QuizBuzz.Quizzes.{Player, Team}

  def add_team(quiz, name) do
    %{quiz | teams: [Team.new(name) | quiz.teams]}
  end

  def join_quiz(quiz, name) do
    %{quiz | players: [Player.new(name) | quiz.players]}
  end
end
