defmodule QuizBuzz.Quizzes.PlayerTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Quizzes.Player

  describe "QuizBuzz.Quizzes.Player.new/1" do
    test "builds a new player with the specified name, with buzzed? set to false" do
      assert Player.new("Joe Bloggs") == %Player{name: "Joe Bloggs", buzzed?: false}
    end
  end
end
