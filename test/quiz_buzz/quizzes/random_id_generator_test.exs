defmodule QuizBuzz.Quizzes.RandomIDGeneratorTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Quizzes.RandomIDGenerator

  setup do
    RandomIDGenerator.start_link([])
    :ok
  end

  describe "QuizBuzz.Quizzes.RandomIDGenerator.next/0" do
    test "returns successive different IDs" do
      ids = 1..3 |> Enum.map(fn _ -> RandomIDGenerator.next() end)
      assert ids |> Enum.uniq() |> length() == 3
    end
  end
end
