defmodule QuizBuzz.RegistryTest do
  use ExUnit.Case, async: false

  alias QuizBuzz.Registry

  setup_all do
    {:ok, _} = Application.ensure_all_started(:quiz_buzz)
    :ok
  end

  test "a quiz can be set up and run", context do
    context
    |> quizmaster_starts_quiz()
    |> quizmaster_adds_team("Team one")
    |> quizmaster_adds_team("Team two")
    |> player_joins_quiz("Alice")
    |> player_joins_team("Alice", "Team one")
    |> player_joins_quiz("Bob")
    |> player_joins_team("Bob", "Team one")
    |> player_joins_quiz("Carol")
    |> player_joins_team("Carol", "Team two")
  end

  defp quizmaster_starts_quiz(context) do
    {:ok, id} = Registry.new_quiz()
    Map.put(context, :id, id)
  end

  defp quizmaster_adds_team(context, team_name) do
    :ok = Registry.add_team(context.id, team_name)
    context
  end

  defp player_joins_quiz(context, player_name) do
    :ok = Registry.join_quiz(context.id, player_name)
    context
  end

  defp player_joins_team(context, player_name, team_name) do
    :ok = Registry.join_team(context.id, team_name, player_name)
    context
  end
end
