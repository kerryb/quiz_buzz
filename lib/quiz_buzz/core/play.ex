defmodule QuizBuzz.Core.Play do
  @moduledoc """
  Functions for playing the quiz.
  """

  alias QuizBuzz.Schema.Quiz

  @spec buzz(Quiz.t(), String.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def buzz(%{state: :active} = quiz, player_name) do
    quiz = %{quiz | players: mark_as_buzzed(quiz.players, player_name), state: :buzzed}
    {:ok, quiz}
  end

  def buzz(_quiz, _player_name), do: {:error, "Buzzers are not currently active"}

  defp mark_as_buzzed(players, player_name) do
    Enum.map(players, &buzzed_if_matched(&1, player_name))
  end

  defp buzzed_if_matched(%{name: player_name} = player, player_name) do
    %{player | buzzed?: true}
  end

  defp buzzed_if_matched(player, _player), do: player

  @spec add_point(Quiz.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def add_point(%{state: :buzzed} = quiz), do: adjust_points(quiz, 1)

  @spec subtract_point(Quiz.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def subtract_point(%{state: :buzzed} = quiz), do: adjust_points(quiz, -1)

  defp adjust_points(quiz, points) do
    quiz = %{
      quiz
      | players: adjust_player_points(quiz.players, points),
        teams: adjust_team_points(quiz.teams, quiz.players, points)
    }

    {:ok, quiz}
  end

  defp adjust_player_points(players, points) do
    Enum.map(players, &adjust_player_points_if_buzzed(&1, points))
  end

  defp adjust_player_points_if_buzzed(%{buzzed?: true} = player, points) do
    %{player | score: player.score + points}
  end

  defp adjust_player_points_if_buzzed(player, _points), do: player

  defp adjust_team_points(teams, players, points) do
    case Enum.find(players, & &1.buzzed?).team do
      nil ->
        teams

      team ->
        Enum.map(teams, &adjust_team_points_if_matched(&1, team_name, points))
    end
  end

  defp adjust_team_points_if_matched(%{name: team_name} = team, team_name, points) do
    %{team | score: team.score + points}
  end

  defp adjust_team_points_if_matched(team, _team_name, _points), do: team

  @spec reset_buzzers(Quiz.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def reset_buzzers(%{state: :buzzed} = quiz) do
    quiz = %{quiz | players: mark_all_as_not_buzzed(quiz.players), state: :active}
    {:ok, quiz}
  end

  def reset_buzzers(_quiz), do: {:error, "No-one has buzzed"}

  defp mark_all_as_not_buzzed(players) do
    Enum.map(players, &%{&1 | buzzed?: false})
  end
end
