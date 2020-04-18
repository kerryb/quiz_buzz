defmodule QuizBuzzWeb.HomeLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.HomeLive" do
    test "disables the 'join quiz' button when the ID has fewer than four characters", %{
      conn: conn
    } do
      {:ok, view, _html} = live(conn, "/")
      render_change(view, "form-change", %{"quiz_id" => "A12"})
      assert has_element?(view, "button[disabled=disabled]")
    end

    test "disables the 'join quiz' button when the ID has more than four characters", %{
      conn: conn
    } do
      {:ok, view, _html} = live(conn, "/")
      render_change(view, "form-change", %{"quiz_id" => "A123Z"})
      assert has_element?(view, "button[disabled=disabled]")
    end

    test "enables the 'join quiz' button when the ID has exactly four characters", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_change(view, "form-change", %{"quiz_id" => "A123"})
      assert has_element?(view, "button:not([disabled])")
    end

    test "redirects to the quiz view when the join button is pressed", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_change(view, "form-change", %{"quiz_id" => "A123"})
      render_click(view, "join")
      assert_redirect(view, "/quiz/A123")
    end
  end
end
