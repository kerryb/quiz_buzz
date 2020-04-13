defmodule QuizBuzz.Schema.TeamTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Schema.Team

  describe "QuizBuzz.Schema.Team.new/1" do
    test "builds a new team with the specified name" do
      assert Team.new("My team") == %Team{name: "My team"}
    end
  end
end
