defmodule QuizBuzzWeb.QuizmasterLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(page_title: "QuizzBuzz: (master)")}
  end
end
