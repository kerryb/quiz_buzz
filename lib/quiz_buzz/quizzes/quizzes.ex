defmodule QuizBuzz.Quizzes do
  alias QuizBuzz.Quizzes.{Player, Team}

  def add_team(quiz, name) do
    %{quiz | teams: [Team.new(name) | quiz.teams]}
  end

  def join_quiz(quiz, name) do
    %{quiz | players: [Player.new(name) | quiz.players]}
  end

  def join_team(quiz, team, player) do
    %{
      quiz
      | teams: add_player_to_team(quiz.teams, team, player),
        players: remove_player(quiz.players, player)
    }
  end

  defp add_player_to_team(teams, team, player) do
    teams |> Enum.map(&update_team_if_matches(&1, team, player))
  end

  defp update_team_if_matches(team, team, player) do
    %{team | players: [player | team.players]}
  end

  defp update_team_if_matches(team, _, _), do: team

  defp remove_player(players, player) do
    players |> Enum.reject(&(&1 == player))
  end
end
