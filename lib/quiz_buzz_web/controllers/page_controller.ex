# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule QuizBuzzWeb.PageController do
  use QuizBuzzWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
