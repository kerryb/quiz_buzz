defmodule QuizBuzzWeb.QuizLive do
  @moduledoc """
  LiveView for the player view of a quiz.
  """

  use Phoenix.LiveView, layout: {QuizBuzzWeb.LayoutView, :live}

  import QuizBuzzWeb.Components

  alias QuizBuzz.Registry
  alias QuizBuzzWeb.Endpoint

  require Logger

  defmodule InvalidQuizIDError do
    @moduledoc false
    defexception message: "Invalid quiz ID", plug_status: 404
  end

  @impl true
  def mount(params, _session, socket) do
    quiz_id = String.upcase(params["quiz_id"])

    case Registry.quiz_from_id(quiz_id) do
      {:ok, quiz} ->
        if connected?(socket), do: Phoenix.PubSub.subscribe(QuizBuzz.PubSub, "quiz:#{quiz_id}")

        {:ok, assign(socket, quiz: quiz, joined?: false, player_name: nil, player_name_valid: false)}

      _error ->
        raise(InvalidQuizIDError)
    end
  end

  @impl true
  def handle_event("form-change", %{"player_name" => player_name}, socket) do
    case Registry.validate_player_name(socket.assigns.quiz.id, player_name) do
      :ok ->
        {:noreply, socket |> assign(player_name: player_name, player_name_valid: true) |> clear_flash()}

      {:error, message} ->
        {:noreply, socket |> assign(player_name_valid: false) |> put_flash(:error, message)}
    end
  end

  def handle_event("join-quiz", _params, socket) do
    case Registry.join_quiz(socket.assigns.quiz.id, socket.assigns.player_name) do
      :ok ->
        {:noreply, assign(socket, joined?: true)}

      # coveralls-ignore-start
      _error ->
        {:noreply, socket}
        # coveralls-ignore-end
    end
  end

  def handle_event("join-team", %{"team" => team}, socket) do
    Registry.join_team(socket.assigns.quiz.id, team, socket.assigns.player_name)
    {:noreply, socket}
  end

  def handle_event("buzz", _params, socket) do
    buzz(socket)
  end

  def handle_event("keydown", %{"key" => " "}, socket) do
    buzz(socket)
  end

  def handle_event("keydown", _params, socket) do
    {:noreply, socket}
  end

  def handle_event(event, params, socket) do
    Logger.warning("Received unexpected event: #{inspect(event)} with params #{inspect(params)}")
    {:noreply, socket}
  end

  defp buzz(socket) do
    Registry.buzz(socket.assigns.quiz.id, socket.assigns.player_name)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:quiz, quiz}, socket) do
    {:noreply, assign(socket, :quiz, quiz)}
  end

  def handle_info(:buzz, socket) do
    Endpoint.broadcast!("buzzer", "sound", %{})
    {:noreply, socket}
  end

  def handle_info(message, socket) do
    Logger.warning("Received unexpected message: #{inspect(message)}")
    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    Registry.leave_quiz(socket.assigns.quiz.id, socket.assigns.player_name)
    {:ok, socket}
  end
end
