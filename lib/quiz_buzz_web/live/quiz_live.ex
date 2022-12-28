defmodule QuizBuzzWeb.QuizLive do
  use QuizBuzzWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, name: nil)}
  end
end
