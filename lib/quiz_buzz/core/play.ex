defmodule QuizBuzz.Core.Play do
  @moduledoc """
  Functions for playing the quiz.
  """

  alias QuizBuzz.Schema.{Player, Quiz}

  @spec buzz(Quiz.t(), Player.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def buzz(%{state: :active} = quiz, player) do
    quiz = %{quiz | players: mark_as_buzzed(quiz.players, player), state: :buzzed}
    {:ok, quiz}
  end

  def buzz(_quiz, _player), do: {:error, "Buzzers are not currently active"}

  defp mark_as_buzzed(players, player) do
    Enum.map(players, &buzzed_if_matched(&1, player))
  end

  defp buzzed_if_matched(player, player), do: %{player | buzzed?: true}
  defp buzzed_if_matched(player, _player), do: player

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
