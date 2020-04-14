defmodule QuizBuzz.RegistryTest do
  use ExUnit.Case, async: false

  alias QuizBuzz.Registry

  setup_all do
    {:ok, _} = Application.ensure_all_started(:quiz_buzz)
    :ok
  end

  setup do
    :ok = Phoenix.PubSub.subscribe(QuizBuzz.PubSub, "quiz_updates")
  end

  test "a quiz can be set up and run" do
    quizmaster_creates_quiz()
    |> quizmaster_adds_team("Team one")
    |> quizmaster_adds_team("Team two")
    |> player_joins_quiz("Alice")
    |> player_joins_team("Alice", "Team one")
    |> player_joins_quiz("Bob")
    |> player_joins_quiz("Carol")
    |> player_joins_team("Bob", "Team one")
    |> quizmaster_starts_quiz()
    |> player_buzzes("Alice")
    |> assert_player_buzzed("Alice")
    |> player_tries_to_buzz("Bob")
    |> assert_quiz_not_updated()
    |> quizmaster_resets_buzzers()
    |> assert_no_player_buzzed()
    |> player_buzzes("Carol")
    |> assert_player_buzzed("Carol")
  end

  defp quizmaster_creates_quiz do
    {:ok, id} = Registry.new_quiz()
    id
  end

  defp quizmaster_adds_team(id, team_name) do
    flush_mailbox()
    :ok = Registry.add_team(id, team_name)
    id
  end

  defp player_joins_quiz(id, player_name) do
    flush_mailbox()
    :ok = Registry.join_quiz(id, player_name)
    id
  end

  defp player_joins_team(id, player_name, team_name) do
    flush_mailbox()
    :ok = Registry.join_team(id, team_name, player_name)
    id
  end

  defp quizmaster_starts_quiz(id) do
    flush_mailbox()
    :ok = Registry.start_quiz(id)
    id
  end

  defp player_buzzes(id, player_name) do
    flush_mailbox()
    :ok = Registry.buzz(id, player_name)
    id
  end

  defp player_tries_to_buzz(id, player_name) do
    # Don't flush mailbox, because we want to check there's no update broadcast
    {:error, _} = Registry.buzz(id, player_name)
    id
  end

  defp quizmaster_resets_buzzers(id) do
    flush_mailbox()
    :ok = Registry.reset_buzzers(id)
    id
  end

  defp assert_player_buzzed(id, player_name) do
    assert_receive({:quiz, quiz} = message)
    assert quiz.state == :buzzed
    assert [%{name: ^player_name}] = Enum.filter(quiz.players, & &1.buzzed?)
    id
  end

  defp assert_no_player_buzzed(id) do
    assert_receive({:quiz, quiz})
    assert quiz.state == :active
    refute Enum.any?(quiz.players, & &1.buzzed?)
    id
  end

  defp assert_quiz_not_updated(id) do
    refute_receive {:quiz, _}
    id
  end

  defp flush_mailbox do
    receive do
      __message -> flush_mailbox()
    after
      0 -> :ok
    end
  end
end
