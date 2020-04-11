defmodule QuizBuzz.Quizzes.Quiz do
  @moduledoc """
  Top level struct (token) for a quiz. Contains the following:

  * a random ID
  * a list of `QuizBuzz.Quizzes.Team`s
  * a list of `QuizBuzz.Quizzes.Player`s who are yet to join a team
  * a state (:setup or :active)
  """

  defstruct [:id, :teams, :players, :state]

  alias QuizBuzz.Quizzes.{Player, Team}

  @type t :: %__MODULE__{id: String.t(), teams: [Team.t()], players: [Player.t()], state: state()}
  @type state :: :setup | :active

  @spec new((() -> String.t())) :: t()
  def new(id_generator) do
    %__MODULE__{id: id_generator.(), teams: [], players: [], state: :setup}
  end
end
