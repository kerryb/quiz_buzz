defmodule QuizBuzz.Quizzes.Player do
  @moduledoc """
  A player in the quiz.
  """

  defstruct [:name]

  def new(name) do
    %__MODULE__{name: name}
  end
end
