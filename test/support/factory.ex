defmodule QuizBuzz.Factory do
  alias QuizBuzz.Quizzes.{Player, Quiz, RandomIDGenerator, Team}

  def new_quiz do
    Quiz.new(&RandomIDGenerator.next/0)
  end

  def with_team(quiz, name, player_names \\ []) do
    players = player_names |> Enum.map(&Player.new/1)
    team = %{Team.new(name) | players: players}
    %{quiz | teams: [team]}
  end

  def with_player(quiz, name) do
    %{quiz | players: [Player.new(name)]}
  end
end
