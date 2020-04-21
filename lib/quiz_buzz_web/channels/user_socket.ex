# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule QuizBuzzWeb.UserSocket do
  use Phoenix.Socket

  alias QuizBuzzWeb.BuzzerChannel

  channel "buzzer", BuzzerChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
