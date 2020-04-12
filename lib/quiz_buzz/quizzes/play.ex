defmodule QuizBuzz.Quizzes.Play do
  @moduledoc """
  Functions for playing the quiz.
  """

  alias QuizBuzz.Quizzes.{Player, Quiz}

  @spec buzz(Quiz.t(), Player.t()) :: Quiz.t()
  def buzz(quiz, player) do
    %{quiz | players: mark_as_buzzed(quiz.players, player)}
  end

  defp mark_as_buzzed(players, player) do
    Enum.map(players, &buzzed_if_matched(&1, player))
  end

  defp buzzed_if_matched(player, player), do: %{player | buzzed?: true}
  defp buzzed_if_matched(player, _player), do: player
end
