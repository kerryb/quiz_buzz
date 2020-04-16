defmodule QuizBuzzWeb.HomeLive do
  @moduledoc """
  LiveView for the home page.
  """

  use Phoenix.LiveView

  alias QuizBuzzWeb.{QuizLive, QuizmasterLive}
  # credo:disable-for-next-line Credo.Check.Readability.AliasAs
  alias QuizBuzzWeb.Router.Helpers, as: Routes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, id_valid: false)}
  end

  @impl true
  def handle_event("join", _params, socket) do
    {:noreply, redirect(socket, to: Routes.live_path(socket, QuizLive, socket.assigns.id))}
  end

  def handle_event("form-change", %{"id" => id}, socket) do
    {:noreply, assign(socket, id: id, id_valid: String.length(id) == 4)}
  end
end
