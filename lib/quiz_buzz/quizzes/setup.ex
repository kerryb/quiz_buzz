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
    if Enum.any?(quiz.players, &(&1.name == name)) do
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
    player = %{player | team: team}
    quiz = %{quiz | players: replace_player(quiz.players, player)}

    {:ok, quiz}
  end

  def join_team(_quiz, _team, _player), do: {:error, "The quiz has already started"}

  defp replace_player(players, player) do
    Enum.map(players, &replace_if_name_matches(&1, player))
  end

  defp replace_if_name_matches(%{name: name}, %{name: name} = new_player), do: new_player
  defp replace_if_name_matches(player, _new_player), do: player

  @spec start(Quiz.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def start(%{state: :setup} = quiz) do
    quiz = %{quiz | state: :active}
    {:ok, quiz}
  end

  def start(_quiz), do: {:error, "The quiz has already started"}
end
