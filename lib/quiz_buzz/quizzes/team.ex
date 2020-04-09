defmodule QuizBuzz.Quizzes.Team do
  defstruct [:name, :players]

  def new(name) do
    %__MODULE__{name: name, players: []}
  end
end
