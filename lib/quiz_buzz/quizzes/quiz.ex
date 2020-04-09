defmodule QuizBuzz.Quizzes.Quiz do
  defstruct [:id, :teams]

  alias QuizBuzz.Quizzes.Team

  def new(id_generator) do
    %__MODULE__{id: id_generator.(), teams: []}
  end

  def add_team(quiz, name) do
    %{quiz | teams: [Team.new(name) | quiz.teams]}
  end
end
