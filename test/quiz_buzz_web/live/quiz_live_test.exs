defmodule QuizBuzzWeb.QuizLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest

  alias QuizBuzz.Registry
  alias QuizBuzzWeb.QuizLive.InvalidQuizdIdError

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizLive" do
    test "404s if the quiz does not exist", %{conn: conn} do
      assert_raise InvalidQuizdIdError, fn -> live(conn, "/quiz/XXXX") end
    end

    test "prompts for the player's name if they have not yet joined", %{conn: conn} do
      {:ok, id} = Registry.new_quiz()
      {:ok, _view, html} = live(conn, "/quiz/#{id}")
      {:ok, dom} = Floki.parse_document(html)
      [{_, attributes, _}] = Floki.find(dom, "input")
      assert {"name", "name"} in attributes
    end
  end
end
