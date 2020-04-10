defmodule QuizBuzz.Quizzes.Quiz do
  defstruct [:id, :teams, :players, :state]

  def new(id_generator) do
    %__MODULE__{id: id_generator.(), teams: [], players: [], state: :setup}
  end
end
