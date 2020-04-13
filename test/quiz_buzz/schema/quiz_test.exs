defmodule QuizBuzz.Schema.QuizTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Schema.Quiz

  describe "QuizBuzz.Schema.Quiz.new/1" do
    test "builds a new quiz with a generated ID" do
      generator = fn -> 42 end
      assert Quiz.new(generator) == %Quiz{id: 42, teams: [], players: [], state: :setup}
    end
  end
end
