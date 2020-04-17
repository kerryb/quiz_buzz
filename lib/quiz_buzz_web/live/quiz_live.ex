defmodule QuizBuzzWeb.QuizLive do
  @moduledoc """
  LiveView for the player view of a quiz.
  """

  use Phoenix.LiveView, layout: {QuizBuzzWeb.LayoutView, "live.html"}

  alias QuizBuzz.Registry

  defmodule InvalidQuizdIdError do
    defexception message: "invalid quiz ID", plug_status: 404
  end

  @impl true
  def mount(params, _session, socket) do
    unless Registry.valid_id?(params["id"]), do: raise(InvalidQuizdIdError)
    {:ok, assign(socket, id: params["id"], name_valid: false)}
  end

  @impl true
  def handle_event("form-change", %{"name" => name}, socket) do
    case Registry.validate_player_name(socket.assigns.id, name) do
      :ok ->
        {:noreply, assign(socket, name_valid: true)}

      {:error, message} ->
        {:noreply, socket |> assign(name_valid: false) |> put_flash(:error, message)}
    end
  end
end
