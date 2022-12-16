defmodule QuizBuzz.Schema.TeamTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Schema.Team

  describe "QuizBuzz.Schema.Team.new/1" do
    test "builds a new team with the specified name and a zero score" do
      assert Team.new("My team") == %Team{name: "My team", score: 0}
    end
  end
end
