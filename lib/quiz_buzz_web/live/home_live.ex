defmodule QuizBuzzWeb.HomeLive do
  @moduledoc """
  LiveView for the home page.
  """

  use Phoenix.LiveView, layout: {QuizBuzzWeb.LayoutView, "live.html"}

  alias QuizBuzzWeb.{QuizLive, QuizmasterLive}
  # credo:disable-for-next-line Credo.Check.Readability.AliasAs
  alias QuizBuzzWeb.Router.Helpers, as: Routes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, quiz_id_valid: false)}
  end

  @impl true
  def handle_event("form-change", %{"quiz_id" => quiz_id}, socket) do
    {:noreply, assign(socket, quiz_id: quiz_id, quiz_id_valid: String.length(quiz_id) == 4)}
  end

  def handle_event("join", _params, socket) do
    {:noreply, redirect(socket, to: Routes.live_path(socket, QuizLive, socket.assigns.quiz_id))}
  end
end
