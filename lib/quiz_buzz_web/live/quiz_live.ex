defmodule QuizBuzzWeb.QuizLive do
  use QuizBuzzWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, name: nil)}
  end

  def handle_event("save-name", %{"name" => name}, socket) do
    {:noreply, assign(socket, name: name)}
  end
end
