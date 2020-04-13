defmodule QuizBuzz.Schema.Player do
  @moduledoc """
  A player in the quiz. They may have an association with a
  `QuizBuzz.Schema.Team`, and may be marked at any point as having buzzed.
  """

  alias QuizBuzz.Schema.Team

  @enforce_keys [:name, :buzzed?]
  defstruct [:name, :team, buzzed?: false]

  @type t :: %__MODULE__{name: String.t(), team: Team.t() | nil, buzzed?: boolean()}

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name, team: nil, buzzed?: false}
  end
end
