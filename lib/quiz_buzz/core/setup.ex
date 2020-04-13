defmodule QuizBuzz.Core.Setup do
  @moduledoc """
  Functions for setting up the quiz with players and teams, before it starts.
  """

  alias QuizBuzz.Schema.{Player, Quiz, Team}

  @spec add_team(Quiz.t(), String.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def add_team(_quiz, ""), do: {:error, "Name must not be blank"}

  def add_team(%{state: :setup} = quiz, name) do
    if Enum.any?(quiz.teams, &(&1.name == name)) do
      {:error, "That name has already been taken"}
    else
      quiz = %{quiz | teams: [Team.new(name) | quiz.teams]}
      {:ok, quiz}
    end
  end

  def add_team(_quiz, _name), do: {:error, "The quiz has already started"}

  @spec join_quiz(Quiz.t(), String.t()) :: {:ok, Quiz.t(), Player.t()} | {:error, String.t()}
  def join_quiz(_quiz, ""), do: {:error, "Name must not be blank"}

  def join_quiz(%{state: :setup} = quiz, name) do
    if Enum.any?(quiz.players, &(&1.name == name)) do
      {:error, "That name has already been taken"}
    else
      player = Player.new(name)
      quiz = %{quiz | players: [player | quiz.players]}
      {:ok, quiz, player}
    end
  end

  def join_quiz(_quiz, _name), do: {:error, "The quiz has already started"}

  @spec join_team(Quiz.t(), Player.t(), Team.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def join_team(%{state: :setup} = quiz, player, team) do
    quiz = %{quiz | players: find_and_update_player_team(quiz.players, player, team)}

    {:ok, quiz}
  end

  def join_team(_quiz, _player, _team), do: {:error, "The quiz has already started"}

  defp find_and_update_player_team(players, player, team) do
    Enum.map(players, &update_player_team(&1, player, team))
  end

  defp update_player_team(player, player, team), do: %{player | team: team}
  defp update_player_team(player, _player_to_update, _team), do: player

  @spec start(Quiz.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def start(%{state: :setup} = quiz) do
    quiz = %{quiz | state: :active}
    {:ok, quiz}
  end

  def start(_quiz), do: {:error, "The quiz has already started"}
end
