defmodule QuizBuzz.Quizzes.Quiz do
  defstruct [:id, :teams]

  def new(id_generator) do
    %__MODULE__{id: id_generator.(), teams: []}
  end
end
