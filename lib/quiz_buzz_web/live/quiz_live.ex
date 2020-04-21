defmodule QuizBuzzWeb.QuizLive do
  @moduledoc """
  LiveView for the player view of a quiz.
  """

  use Phoenix.LiveView, layout: {QuizBuzzWeb.LayoutView, "live.html"}

  alias QuizBuzz.Registry

  defmodule InvalidQuizIDError do
    defexception message: "Invalid quiz ID", plug_status: 404
  end

  @impl true
  def mount(params, _session, socket) do
    unless Registry.valid_id?(params["quiz_id"]), do: raise(InvalidQuizIDError)

    if connected?(socket),
      do: Phoenix.PubSub.subscribe(QuizBuzz.PubSub, "quiz:#{params["quiz_id"]}")

    {:ok,
     assign(socket,
       quiz_id: params["quiz_id"],
       quiz: nil,
       player_name_valid: false
     )}
  end

  @impl true
  def handle_event("form-change", %{"player_name" => player_name}, socket) do
    case Registry.validate_player_name(socket.assigns.quiz_id, player_name) do
      :ok ->
        {:noreply,
         socket |> assign(player_name: player_name, player_name_valid: true) |> clear_flash()}

      {:error, message} ->
        {:noreply, socket |> assign(player_name_valid: false) |> put_flash(:error, message)}
    end
  end

  def handle_event("join-quiz", _params, socket) do
    :ok = Registry.join_quiz(socket.assigns.quiz_id, socket.assigns.player_name)
    {:noreply, socket}
  end

  def handle_event("join-team", %{"team" => team}, socket) do
    :ok = Registry.join_team(socket.assigns.quiz_id, team, socket.assigns.player_name)
    {:noreply, socket}
  end

  def handle_event("buzz", _params, socket) do
    :ok = Registry.buzz(socket.assigns.quiz_id, socket.assigns.player_name)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:quiz, quiz}, socket) do
    {:noreply, assign(socket, :quiz, quiz)}
  end
end
