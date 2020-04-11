defmodule QuizBuzz.Quizzes.RandomIDGenerator do
  @moduledoc """
  An agent responsible for providing unique random four-character IDs for
  quizzes. When started it will seed itself randomly.
  """

  use Agent

  @alphabet "ABCDEFGHJKLMNPQRSTUVWZYZ23456789"

  @spec start_link(any()) :: Agent.on_start()
  def start_link(_arg) do
    Agent.start_link(
      fn ->
        %{hashids: Hashids.new(salt: initial_salt(), min_len: 4, alphabet: @alphabet), index: 0}
      end,
      name: __MODULE__
    )
  end

  @spec next() :: String.t()
  def next do
    Agent.get_and_update(__MODULE__, fn %{hashids: hashids, index: index} = state ->
      {Hashids.encode(hashids, index), %{state | index: index + 1}}
    end)
  end

  defp initial_salt do
    :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16)
  end
end
