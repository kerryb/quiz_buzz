defmodule QuizBuzz.Quizzes.RandomIDGenerator do
  use Agent

  @alphabet "ABCDEFGHJKLMNPQRSTUVWZYZ23456789"

  def start_link(_) do
    Agent.start_link(
      fn ->
        %{hashids: Hashids.new(salt: initial_salt(), min_len: 4, alphabet: @alphabet), index: 0}
      end,
      name: __MODULE__
    )
  end

  def next() do
    Agent.get_and_update(__MODULE__, fn %{hashids: hashids, index: index} = state ->
      {Hashids.encode(hashids, index), %{state | index: index + 1}}
    end)
  end

  defp initial_salt do
    :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16)
  end
end
