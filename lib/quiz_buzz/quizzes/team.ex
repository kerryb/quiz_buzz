defmodule QuizBuzz.Quizzes.Team do
  @moduledoc """
  A team belongs to a `QuizBuzz.Quizzes.Quiz`, and has a list of `QuizBuzz.Quizzes.Player`s.
  """

  defstruct [:name, :players]

  def new(name) do
    %__MODULE__{name: name, players: []}
  end
end
