defmodule QuizBuzz.Registry do
  @moduledoc """
  A registry of quizzes, serving as the API boundary.
  """

  use Agent

  alias QuizBuzz.Core
  alias QuizBuzz.Schema.Quiz

  @spec start_link(any()) :: Agent.on_start()
  def start_link(_arg) do
    Agent.start_link(fn -> %{quizzes: %{}, secrets: %{}} end, name: __MODULE__)
  end

  @spec new_quiz :: {:ok, Quiz.t()} | {:error, String.t()}
  def new_quiz do
    with {:ok, quiz} <- Core.new_quiz() do
      register_quiz(quiz)
      {:ok, quiz}
    end
  end

  @spec quiz_from_id(String.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def quiz_from_id(id) do
    case get_quiz(id) do
      nil -> {:error, "Quiz not found"}
      quiz -> {:ok, quiz}
    end
  end

  @spec quiz_from_secret_id(String.t()) :: {:ok, Quiz.t()} | {:error, String.t()}
  def quiz_from_secret_id(secret_id) do
    Agent.get(__MODULE__, fn %{quizzes: quizzes, secrets: secrets} ->
      {:ok, id} = Map.fetch(secrets, secret_id)
      Map.fetch(quizzes, id)
    end)
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

  @spec leave_quiz(String.t(), String.t()) :: :ok | {:error, String.t()}
  def leave_quiz(id, name) do
    with quiz <- get_quiz(id),
         {:ok, quiz} <- Core.leave_quiz(quiz, name),
         :ok <- update_quiz(id, quiz) do
      :ok
    end
  end

  @spec validate_player_name(String.t(), String.t()) :: :ok | {:error, String.t()}
  def validate_player_name(id, name) do
    with quiz <- get_quiz(id) do
      Core.validate_player_name(quiz, name)
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

  @spec start_quiz(String.t()) :: :ok | {:error, String.t()}
  def start_quiz(id) do
    with quiz <- get_quiz(id),
         {:ok, quiz} <- Core.start(quiz),
         :ok <- update_quiz(id, quiz) do
      :ok
    end
  end

  @spec buzz(String.t(), String.t()) :: :ok | {:error, String.t()}
  def buzz(id, player_name) do
    with quiz <- get_quiz(id),
         {:ok, quiz} <- Core.buzz(quiz, player_name),
         :ok <- buzz(quiz),
         :ok <- update_quiz(id, quiz) do
      :ok
    end
  end

  @spec reset_buzzers(String.t()) :: :ok | {:error, String.t()}
  def reset_buzzers(id) do
    with quiz <- get_quiz(id),
         {:ok, quiz} <- Core.reset_buzzers(quiz),
         :ok <- update_quiz(id, quiz) do
      :ok
    end
  end

  defp register_quiz(quiz) do
    Agent.update(
      __MODULE__,
      &(&1
        |> put_in([:quizzes, quiz.id], quiz)
        |> put_in([:secrets, quiz.secret_id], quiz.id))
    )
  end

  defp get_quiz(id) do
    Agent.get(__MODULE__, &get_in(&1, [:quizzes, id]))
  end

  defp update_quiz(id, quiz) do
    Phoenix.PubSub.broadcast(QuizBuzz.PubSub, "quiz:#{quiz.id}", {:quiz, quiz})
    Agent.update(__MODULE__, &put_in(&1, [:quizzes, id], quiz))
  end

  defp buzz(quiz) do
    Phoenix.PubSub.broadcast(QuizBuzz.PubSub, "quiz:#{quiz.id}", :buzz)
  end
end
