defmodule QuizBuzz.Core.PlayerTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Schema.Player

  describe "QuizBuzz.Core.Player.new/1" do
    test "builds a new player with the specified name, with buzzed? set to false" do
      assert Player.new("Joe Bloggs") == %Player{name: "Joe Bloggs", buzzed?: false}
    end
  end
end
