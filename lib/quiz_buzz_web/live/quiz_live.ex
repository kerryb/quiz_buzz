defmodule QuizBuzzWeb.QuizLive do
  @moduledoc """
  LiveView for the player view of a quiz.
  """

  use Phoenix.LiveView, layout: {QuizBuzzWeb.LayoutView, "live.html"}

  alias QuizBuzz.Registry

  defmodule InvalidQuizdIdError do
    defexception message: "invalid quiz ID", plug_status: 404
  end

  @impl true
  def mount(params, _session, socket) do
    unless Registry.valid_id?(params["id"]), do: raise(InvalidQuizdIdError)
    {:ok, assign(socket, id: params["id"], name_valid: false)}
  end
end
