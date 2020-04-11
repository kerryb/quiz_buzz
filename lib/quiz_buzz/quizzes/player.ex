defmodule QuizBuzz.Quizzes.Player do
  @moduledoc """
  A player in the quiz.
  """

  defstruct [:name]

  @type t :: %__MODULE__{name: String.t()}

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name}
  end
end
