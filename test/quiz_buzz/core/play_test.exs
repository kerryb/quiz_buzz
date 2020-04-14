defmodule QuizBuzz.Core.PlayTest do
  use ExUnit.Case, async: true

  import QuizBuzz.Factory

  alias QuizBuzz.Core.Play
  alias QuizBuzz.Schema.Player

  describe "QuizBuzz.Core.Play.buzz/2" do
    setup do
      jane_doe = Player.new("Jane Doe")
      joe_bloggs = Player.new("Joe Bloggs")
      quiz = active_quiz() |> with_player(jane_doe) |> with_player(joe_bloggs)
      {:ok, quiz: quiz}
    end

    test "marks the correct player as having buzzed", %{quiz: quiz} do
      {:ok, quiz} = Play.buzz(quiz, "Jane Doe")

      assert Enum.map(quiz.players, &{&1.name, &1.buzzed?}) == [
               {"Joe Bloggs", false},
               {"Jane Doe", true}
             ]
    end

    test "updates the quiz state to buzzed", %{quiz: quiz} do
      {:ok, quiz} = Play.buzz(quiz, "Jane Doe")
      assert quiz.state == :buzzed
    end

    test "fails unless the quiz is in the active state", %{quiz: quiz} do
      quiz = %{quiz | state: :buzzed}
      assert {:error, _} = Play.buzz(quiz, "Jane Doe")
    end
  end

  describe "QuizBuzz.Core.Play.reset_buzzers/1" do
    setup do
      jane_doe = %{Player.new("Jane Doe") | buzzed?: true}
      joe_bloggs = Player.new("Joe Bloggs")
      quiz = buzzed_quiz() |> with_player(jane_doe) |> with_player(joe_bloggs)
      {:ok, quiz: quiz}
    end

    test "marks all players as not having buzzed", %{quiz: quiz} do
      {:ok, quiz} = Play.reset_buzzers(quiz)
      refute Enum.any?(quiz.players, & &1.buzzed?)
    end

    test "updates the quiz state to active", %{quiz: quiz} do
      {:ok, quiz} = Play.reset_buzzers(quiz)
      assert quiz.state == :active
    end

    test "fails unless the quiz is in the buzzed state", %{quiz: quiz} do
      quiz = %{quiz | state: :active}
      assert {:error, _} = Play.reset_buzzers(quiz)
    end
  end
end
