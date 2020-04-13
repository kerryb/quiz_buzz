defmodule QuizBuzz.Quizzes.Player do
  @moduledoc """
  A player in the quiz.
  """

  @enforce_keys [:name, :buzzed?]
  defstruct [:name, buzzed?: false]

  @type t :: %__MODULE__{name: String.t(), buzzed?: boolean()}

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name, buzzed?: false}
  end
end
