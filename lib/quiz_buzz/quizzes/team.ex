defmodule QuizBuzz.Quizzes.Team do
  @moduledoc """
  A team belongs to a `QuizBuzz.Quizzes.Quiz`, and has a list of `QuizBuzz.Quizzes.Player`s.
  """

  @enforce_keys [:name]
  defstruct [:name]

  @type t :: %__MODULE__{name: String.t()}

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name}
  end
end
