defmodule QuizBuzzWeb.QuizLive do
  @moduledoc """
  LiveView for the player view of a quiz.
  """

  use Phoenix.LiveView, layout: {QuizBuzzWeb.LayoutView, "live.html"}

  defmodule InvalidQuizdIdError do
    defexception message: "invalid quiz ID", plug_status: 404
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, id: params["id"])}
    raise InvalidQuizdIdError
  end
end
