defmodule QuizBuzz.Registry do
  @moduledoc """
  A registry of quizzes, serving as the API boundary.
  """

  use Agent

  alias QuizBuzz.Core

  @spec start_link(any()) :: Agent.on_start()
  def start_link(_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec new_quiz :: {:ok, String.t()} | {:error, String.t()}
  def new_quiz do
    with {:ok, quiz} <- Core.new_quiz() do
      register_quiz(quiz)
      {:ok, quiz.id}
    end
  end

  @spec add_team(String.t(), String.t()) :: :ok | {:error, String.t()}
  def add_team(id, name) do
    with quiz <- get_quiz(id),
         {:ok, quiz} <- Core.add_team(quiz, name),
         :ok <- update_quiz(id, quiz) do
      :ok
    end
  end

  @spec join_quiz(String.t(), String.t()) :: :ok | {:error, String.t()}
  def join_quiz(id, name) do
    with quiz <- get_quiz(id),
         {:ok, quiz} <- Core.join_quiz(quiz, name),
         :ok <- update_quiz(id, quiz) do
      :ok
    end
  end

  @spec join_team(String.t(), String.t(), String.t()) :: :ok | {:error, String.t()}
  def join_team(id, team_name, player_name) do
    with quiz <- get_quiz(id),
         {:ok, quiz} <- Core.join_team(quiz, player_name, team_name),
         :ok <- update_quiz(id, quiz) do
      :ok
    end
  end

  defp register_quiz(quiz) do
    Agent.update(__MODULE__, &Map.put_new(&1, quiz.id, quiz))
  end

  defp get_quiz(id) do
    Agent.get(__MODULE__, &Map.fetch!(&1, id))
  end

  defp update_quiz(id, quiz) do
    Agent.update(__MODULE__, &Map.put(&1, id, quiz))
  end
end
