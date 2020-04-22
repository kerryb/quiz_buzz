# credo:disable-for-this-file Credo.Check.Refactor.ModuleDependencies
defmodule QuizBuzzWeb.QuizmasterLive do
  @moduledoc """
  LiveView for the quizmaster view of a quiz.
  """

  use Phoenix.HTML
  use Phoenix.LiveView, layout: {QuizBuzzWeb.LayoutView, "live.html"}

  alias QuizBuzz.Registry
  alias QuizBuzzWeb.{Endpoint, QuizLive}
  # credo:disable-for-next-line Credo.Check.Readability.AliasAs
  alias QuizBuzzWeb.Router.Helpers, as: Routes

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, init(socket)}
  end

  defp init(%{connected?: true} = socket) do
    {:ok, quiz} = Registry.new_quiz()
    Phoenix.PubSub.subscribe(QuizBuzz.PubSub, "quiz:#{quiz.id}")

    assign(socket,
      quiz: quiz,
      quiz_url: Routes.live_url(socket, QuizLive, quiz.id),
      team_name_valid: false,
      page_title: "QuizBuzz: #{quiz.id} (master)"
    )
  end

  defp init(socket) do
    assign(socket, quiz: nil)
  end

  @impl true
  def handle_event("form-change", %{"team_name" => team_name}, socket) do
    {:noreply,
     assign(socket,
       team_name: team_name,
       team_name_valid: not (team_name in ["" | Enum.map(socket.assigns.quiz.teams, & &1.name)])
     )}
  end

  def handle_event("add-team", _params, socket) do
    :ok = Registry.add_team(socket.assigns.quiz.id, socket.assigns.team_name)
    {:noreply, socket}
  end

  def handle_event("start-quiz", _params, socket) do
    :ok = Registry.start_quiz(socket.assigns.quiz.id)
    {:noreply, socket}
  end

  def handle_event("reset-buzzers", _params, socket) do
    :ok = Registry.reset_buzzers(socket.assigns.quiz.id)
    {:noreply, socket}
  end

  def handle_event(event, params, socket) do
    Logger.warn("Received unexpected event: #{inspect(event)} with params #{inspect(params)}")
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
    Logger.warn("Received unexpected message: #{inspect(message)}")
    {:noreply, socket}
  end
end
