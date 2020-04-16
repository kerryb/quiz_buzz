defmodule QuizBuzzWeb.QuizLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest
  alias QuizBuzzWeb.QuizLive.InvalidQuizdIdError

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.QuizLive" do
    test "404s if the quiz does not exist", %{conn: conn} do
      assert_raise InvalidQuizdIdError, fn -> live(conn, "/quiz/XXXX") end
    end
  end
end
