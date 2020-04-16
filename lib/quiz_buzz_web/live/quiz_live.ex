defmodule QuizBuzzWeb.QuizLive do
  @moduledoc """
  LiveView for the player view of a quiz.
  """

  use Phoenix.LiveView

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, id: params["id"])}
  end
end
