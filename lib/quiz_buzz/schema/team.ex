defmodule QuizBuzz.Schema.Team do
  @moduledoc """
  A team belongs to a `QuizBuzz.Schema.Quiz`.
  """

  @enforce_keys [:name]
  defstruct [:name]

  @type t :: %__MODULE__{name: String.t()}

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name}
  end
end
