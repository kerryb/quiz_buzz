# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule QuizBuzz.Schema.QuizTest do
  use ExUnit.Case, async: true

  alias QuizBuzz.Schema.Quiz

  defmodule TestGenerator do
    use Agent
    def start_link, do: Agent.start_link(fn -> 0 end, name: __MODULE__)
    def next, do: Agent.get_and_update(__MODULE__, &{&1 + 1, &1 + 1})
  end

  describe "QuizBuzz.Schema.Quiz.new/1" do
    setup do
      TestGenerator.start_link()
      :ok
    end

    test "builds a new quiz with generated IDs" do
      assert Quiz.new(&TestGenerator.next/0) == %Quiz{
               id: 1,
               secret_id: 2,
               teams: [],
               players: [],
               state: :setup
             }
    end
  end
end
