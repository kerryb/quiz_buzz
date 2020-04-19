defmodule QuizBuzzWeb.QuizmasterLive do
  @moduledoc """
  LiveView for the quizmaster view of a quiz.
  """

  use Phoenix.HTML
  use Phoenix.LiveView, layout: {QuizBuzzWeb.LayoutView, "live.html"}

  alias QuizBuzz.Registry
  alias QuizBuzzWeb.QuizLive
  # credo:disable-for-next-line Credo.Check.Readability.AliasAs
  alias QuizBuzzWeb.Router.Helpers, as: Routes

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
      page_title: "QuizzBuzz: #{quiz.id} (master)"
    )
  end

  defp init(socket) do
    assign(socket, quiz: nil)
  end

  @impl true
  def handle_event("form-change", %{"name" => _name}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:quiz, quiz}, socket) do
    {:noreply, assign(socket, :quiz, quiz)}
  end
end
