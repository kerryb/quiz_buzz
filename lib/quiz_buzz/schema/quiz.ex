defmodule QuizBuzz.Schema.Quiz do
  @moduledoc """
  Top level struct (token) for a quiz. Contains the following:

  * a random ID
  * a list of `QuizBuzz.Schema.Team`s
  * a list of `QuizBuzz.Schema.Player`s who are yet to join a team
  * a state (:setup or :active)
  """

  alias QuizBuzz.Schema.{Player, Team}

  @enforce_keys [:id, :teams, :players, :state]
  defstruct [:id, teams: [], players: [], state: []]

  @type t :: %__MODULE__{id: String.t(), teams: [Team.t()], players: [Player.t()], state: state()}
  @type state :: :setup | :active | :buzzed

  @spec new((() -> String.t())) :: t()
  def new(id_generator) do
    %__MODULE__{id: id_generator.(), teams: [], players: [], state: :setup}
  end
end
