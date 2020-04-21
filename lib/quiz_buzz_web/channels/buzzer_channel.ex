defmodule QuizBuzzWeb.BuzzerChannel do
  @moduledoc """
  Channel to allow server-side code (LiveView) to trigger the buzzer, using the
  HTML5 sound API.
  """

  use QuizBuzzWeb, :channel

  @impl true
  def join("buzzer", _payload, socket) do
    {:ok, socket}
  end
end
