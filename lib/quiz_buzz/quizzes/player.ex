defmodule QuizBuzz.Quizzes.Player do
  @moduledoc """
  A player in the quiz.
  """

  defstruct name: nil, buzzed?: false

  @type t :: %__MODULE__{name: String.t(), buzzed?: boolean()}

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name}
  end
end
