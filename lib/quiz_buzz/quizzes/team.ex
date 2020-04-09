defmodule QuizBuzz.Quizzes.Team do
  defstruct [:name]

  def new(name) do
    %__MODULE__{name: name}
  end
end
