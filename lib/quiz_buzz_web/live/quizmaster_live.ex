# credo:disable-for-this-file Credo.Check.Refactor.ModuleDependencies
defmodule QuizBuzzWeb.QuizmasterLive do
  @moduledoc """
  LiveView for the quizmaster view of a quiz.
  """

  use PhoenixHTMLHelpers
  use Phoenix.LiveView, layout: {QuizBuzzWeb.LayoutView, :live}

  import QuizBuzzWeb.Components

  alias QuizBuzz.Registry
  alias QuizBuzzWeb.Endpoint
  alias QuizBuzzWeb.QuizLive
  # credo:disable-for-next-line Credo.Check.Readability.AliasAs
  alias QuizBuzzWeb.Router.Helpers, as: Routes

  require Logger

  @impl true
  def mount(%{"secret_id" => secret_id}, _session, socket) do
    {:ok, quiz} = Registry.quiz_from_secret_id(secret_id)
    Phoenix.PubSub.subscribe(QuizBuzz.PubSub, "quiz:#{quiz.id}")

    {:ok,
     assign(socket,
       quiz: quiz,
       quiz_url: Routes.live_url(socket, QuizLive, quiz.id),
       team_name_valid: false,
       page_title: "QuizBuzz: #{quiz.id} (master)"
     )}
  end

  def mount(_params, _session, socket) do
    {:ok, quiz} = Registry.new_quiz()
    {:ok, redirect(socket, to: Routes.quizmaster_path(socket, :show, quiz.secret_id))}
  end

  @impl true
  def handle_event("form-change", %{"team_name" => team_name}, socket) do
    {:noreply,
     socket
     |> clear_flash()
     |> assign(
       team_name: team_name,
       team_name_valid: team_name not in ["" | Enum.map(socket.assigns.quiz.teams, & &1.name)]
     )}
  end

  def handle_event("add-team", _params, socket) do
    socket.assigns.quiz.id
    |> Registry.add_team(socket.assigns.team_name)
    |> display_flash_if_error(socket)
  end

  def handle_event("start-quiz", _params, socket) do
    Registry.start_quiz(socket.assigns.quiz.id)
    {:noreply, socket}
  end

  def handle_event("reset-buzzers", _params, socket) do
    Registry.reset_buzzers(socket.assigns.quiz.id)
    {:noreply, socket}
  end

  # coveralls-ignore-start
  def handle_event(event, params, socket) do
    Logger.warning("Received unexpected event: #{inspect(event)} with params #{inspect(params)}")
    {:noreply, socket}
  end

  # coveralls-ignore-stop

  @impl true
  def handle_info({:quiz, quiz}, socket) do
    {:noreply, assign(socket, :quiz, quiz)}
  end

  def handle_info(:buzz, socket) do
    Endpoint.broadcast!("buzzer", "sound", %{})
    {:noreply, socket}
  end

  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  # coveralls-ignore-start
  def handle_info(message, socket) do
    Logger.warning("Received unexpected message: #{inspect(message)}")
    {:noreply, socket}
  end

  # coveralls-ignore-stop

  defp display_flash_if_error({:error, message}, socket) do
    Process.send_after(
      self(),
      :clear_flash,
      Application.get_env(:quiz_buzz, :flash_persist_milliseconds)
    )

    {:noreply, put_flash(socket, :error, message)}
  end

  defp display_flash_if_error(_response, socket), do: {:noreply, socket}
end
