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
    if connected?(socket), do: Phoenix.PubSub.subscribe(QuizBuzz.PubSub, "quiz_updates")
    {:ok, init(socket)}
  end

  defp init(%{connected?: true} = socket) do
    {:ok, quiz_id} = Registry.new_quiz()

    assign(socket,
      quiz_id: quiz_id,
      quiz: nil,
      quiz_url: Routes.live_url(socket, QuizLive, quiz_id),
      page_title: "QuizzBuzz: #{quiz_id} (master)"
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
