defmodule QuizBuzz.Schema.Team do
  @moduledoc """
  A team belongs to a `QuizBuzz.Schema.Quiz`.
  """

  @enforce_keys [:name, :points]
  defstruct [:name, :points]

  @type t :: %__MODULE__{name: String.t(), points: integer()}

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name, points: 0}
  end
end
