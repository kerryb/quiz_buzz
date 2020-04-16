defmodule QuizBuzzWeb.QuizmasterLive do
  @moduledoc """
  LiveView for the quizmaster view of a quiz.
  """

  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "QuizzBuzz: (master)")}
  end
end
