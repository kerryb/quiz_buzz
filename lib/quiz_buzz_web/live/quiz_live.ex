defmodule QuizBuzzWeb.QuizLive do
  use Phoenix.LiveView

  def mount(params, _session, socket) do
    IO.inspect(params)
    {:ok, assign(socket, id: params["id"])}
  end
end
