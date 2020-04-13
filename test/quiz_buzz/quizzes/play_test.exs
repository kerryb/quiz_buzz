defmodule QuizBuzz.Quizzes.PlayTest do
  use ExUnit.Case, async: true

  import QuizBuzz.Factory

  alias QuizBuzz.Quizzes.{Play, Player}

  describe "QuizBuzz.Quizzes.Play.buzz/2" do
    setup do
      jane_doe = Player.new("Jane Doe")
      joe_bloggs = Player.new("Joe Bloggs")
      quiz = active_quiz() |> with_player(jane_doe) |> with_player(joe_bloggs)
      {:ok, quiz: quiz, jane_doe: jane_doe}
    end

    test "marks the correct player as having buzzed", %{quiz: quiz, jane_doe: jane_doe} do
      {:ok, quiz} = Play.buzz(quiz, jane_doe)

      assert Enum.map(quiz.players, &{&1.name, &1.buzzed?}) == [
               {"Joe Bloggs", false},
               {"Jane Doe", true}
             ]
    end

    test "updates the quiz state to buzzed", %{quiz: quiz, jane_doe: jane_doe} do
      {:ok, quiz} = Play.buzz(quiz, jane_doe)
      assert quiz.state == :buzzed
    end

    test "fails unless the quiz is in the active state", %{quiz: quiz, jane_doe: jane_doe} do
      quiz = %{quiz | state: :buzzed}
      assert {:error, _} = Play.buzz(quiz, jane_doe)
    end
  end
end
