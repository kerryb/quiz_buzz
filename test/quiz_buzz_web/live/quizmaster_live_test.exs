defmodule QuizBuzzWeb.QuizmasterLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizmasterLive" do
    test "Displays the quiz ID", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/quizmaster")
      assert has_element?(view, ".qb-quiz_id", ~r/.{4}/)
    end

    test "Includes a link to the the quiz", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/quizmaster")
      assert has_element?(view, "a.qb-quiz-url", ~r(/quiz/.{4}))
    end
  end
end
