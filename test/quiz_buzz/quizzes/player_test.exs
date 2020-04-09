defmodule QuizBuzz.Quizzes.PlayerTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Quizzes.Player

  describe "QuizBuzz.Quizzes.Player.new/1" do
    test "builds a new player with the specified name" do
      assert Player.new("Joe Bloggs") == %Player{name: "Joe Bloggs"}
    end
  end
end
