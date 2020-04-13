defmodule QuizBuzz.Core.RandomIDGeneratorTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Core.RandomIDGenerator

  setup do
    RandomIDGenerator.start_link([])
    :ok
  end

  describe "QuizBuzz.Core.RandomIDGenerator.next/0" do
    test "returns successive different IDs" do
      ids = Enum.map(1..3, fn _i -> RandomIDGenerator.next() end)
      assert ids |> Enum.uniq() |> length() == 3
    end
  end
end
