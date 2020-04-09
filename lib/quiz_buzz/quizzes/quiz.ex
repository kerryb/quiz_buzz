defmodule QuizBuzz.Quizzes.Quiz do
  defstruct [:id, :teams, :players]

  def new(id_generator) do
    %__MODULE__{id: id_generator.(), teams: [], players: []}
  end
end
