defmodule QuizBuzz.Quizzes do
  alias QuizBuzz.Quizzes.Team

  def add_team(quiz, name) do
    %{quiz | teams: [Team.new(name) | quiz.teams]}
  end
end
