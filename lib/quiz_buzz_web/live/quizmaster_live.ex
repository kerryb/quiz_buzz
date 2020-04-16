defmodule QuizBuzzWeb.QuizmasterLive do
  @moduledoc """
  LiveView for the quizmaster view of a quiz.
  """

  use Phoenix.{HTML, LiveView}

  alias QuizBuzz.Registry
  alias QuizBuzzWeb.QuizLive
  # credo:disable-for-next-line Credo.Check.Readability.AliasAs
  alias QuizBuzzWeb.Router.Helpers, as: Routes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, init(socket)}
  end

  defp init(%{connected?: true} = socket) do
    {:ok, id} = Registry.new_quiz()

    assign(socket,
      id: id,
      quiz_url: Routes.live_url(socket, QuizLive, id),
      page_title: "QuizzBuzz: #{id} (master)"
    )
  end

  defp init(socket) do
    assign(socket, id: nil)
  end
end
