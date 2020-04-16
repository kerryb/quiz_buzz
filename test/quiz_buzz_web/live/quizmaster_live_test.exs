defmodule QuizBuzzWeb.QuizmasterLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizmasterLive" do
    test "Displays the quiz ID", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/quizmaster")
      {:ok, dom} = Floki.parse_document(html)
      [{_, _, [id]}] = Floki.find(dom, ".qb-id")
      assert id =~ ~r/..../
    end

    test "Includes a link to the the quiz", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/quizmaster")
      {:ok, dom} = Floki.parse_document(html)
      [url] = Floki.attribute(dom, "a.qb-quiz-url", "href")
      assert url =~ ~r{/quiz/...}
    end
  end
end
