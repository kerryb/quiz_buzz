defmodule QuizBuzz.Quizzes.Team do
  @moduledoc """
  A team belongs to a `QuizBuzz.Quizzes.Quiz`, and has a list of `QuizBuzz.Quizzes.Player`s.
  """

  alias QuizBuzz.Quizzes.Player

  defstruct [:name, :players]

  @type t :: %__MODULE__{name: String.t(), players: [Player.t()]}

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name, players: []}
  end
end
