defmodule QuizBuzz.Quizzes.Player do
  @moduledoc """
  A player in the quiz.
  """

  alias QuizBuzz.Quizzes.Team

  @enforce_keys [:name, :buzzed?]
  defstruct [:name, :team, buzzed?: false]

  @type t :: %__MODULE__{name: String.t(), team: Team.t() | nil, buzzed?: boolean()}

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name, team: nil, buzzed?: false}
  end
end
