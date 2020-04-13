defmodule QuizBuzz.Quizzes.Setup do
  @moduledoc """
  Functions for setting up the quiz with players and teams, before it starts.
  """

  alias QuizBuzz.Quizzes.{Player, Quiz, Team}

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
    team_players = Enum.flat_map(quiz.teams, & &1.players)
    players = quiz.players ++ team_players

    if Enum.any?(players, &(&1.name == name)) do
      {:error, "That name has already been taken"}
    else
      player = Player.new(name)
      quiz = %{quiz | players: [player | quiz.players]}
      {:ok, quiz, player}
    end
  end

  def join_quiz(_quiz, _name), do: {:error, "The quiz has already started"}

  @spec join_team(Quiz.t(), Team.t(), Player.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def join_team(%{state: :setup} = quiz, team, player) do
    quiz = %{
      quiz
      | teams: add_player_to_team(quiz.teams, team, player),
        players: remove_player(quiz.players, player)
    }

    {:ok, quiz}
  end

  def join_team(_quiz, _team, _player), do: {:error, "The quiz has already started"}

  defp add_player_to_team(teams, team, player) do
    Enum.map(teams, &update_team_if_matches(&1, team, player))
  end

  defp update_team_if_matches(team, team, player) do
    %{team | players: [player | team.players]}
  end

  defp update_team_if_matches(team, _team, _player), do: team

  defp remove_player(players, player) do
    Enum.reject(players, &(&1 == player))
  end

  @spec start(Quiz.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def start(%{state: :setup} = quiz) do
    quiz = %{quiz | state: :active}
    {:ok, quiz}
  end

  def start(_quiz), do: {:error, "The quiz has already started"}
end