# credo:disable-for-this-file Credo.Check.Readability.SinglePipe

defmodule QuizBuzz.Quizzes.PlayTest do
  use ExUnit.Case, async: true

  import QuizBuzz.Factory

  alias QuizBuzz.Quizzes.{Play, Player}

  describe "QuizBuzz.Quizzes.Play.buzz/2" do
    setup do
      jane_doe = Player.new("Jane Doe")
      joe_bloggs = Player.new("Joe Bloggs")
      quiz = active_quiz() |> with_player(jane_doe) |> with_player(joe_bloggs)
      {:ok, quiz: quiz, jane_doe: jane_doe, joe_bloggs: joe_bloggs}
    end

    test "marks the player as having buzzed", %{quiz: quiz, jane_doe: jane_doe} do
      quiz = Play.buzz(quiz, jane_doe)
      jane_doe = Enum.find(quiz.players, &(&1.name == jane_doe.name))
      assert jane_doe.buzzed?
    end

    test "does not mark other players as having buzzed", %{
      quiz: quiz,
      jane_doe: jane_doe,
      joe_bloggs: joe_bloggs
    } do
      quiz = Play.buzz(quiz, jane_doe)
      joe_bloggs = Enum.find(quiz.players, &(&1.name == joe_bloggs.name))
      refute joe_bloggs.buzzed?
    end
  end
end
