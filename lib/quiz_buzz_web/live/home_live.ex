defmodule QuizBuzzWeb.HomeLive do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  alias QuizBuzzWeb.Router.Helpers, as: Routes
  alias QuizBuzzWeb.{QuizLive, QuizmasterLive}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, id_valid: false)}
  end

  def handle_event("join", _params, socket) do
    {:noreply, redirect(socket, to: Routes.live_path(socket, QuizLive, socket.assigns.id))}
  end

  def handle_event("form-change", %{"id" => id}, socket) do
    {:noreply, assign(socket, id: id, id_valid: String.length(id) == 4)}
  end
end
