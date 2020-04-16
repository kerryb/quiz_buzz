defmodule QuizBuzzWeb.HomeLiveTest do
  use QuizBuzzWeb.ConnCase

  import Phoenix.LiveViewTest

  @endpoint QuizBuzzWeb.Endpoint

  describe "QuizBuzzWeb.HomeLiveTest" do
    test "disables the 'join quiz' button when the ID has fewer than four characters", %{
      conn: conn
    } do
      {:ok, view, _html} = live(conn, "/")
      html = render_change(view, "form-change", %{"id" => "A12"})
      {:ok, dom} = Floki.parse_document(html)
      assert Floki.attribute(dom, "button", "disabled") == ["disabled"]
    end

    test "disables the 'join quiz' button when the ID has more than four characters", %{
      conn: conn
    } do
      {:ok, view, _html} = live(conn, "/")
      html = render_change(view, "form-change", %{"id" => "A123Z"})
      {:ok, dom} = Floki.parse_document(html)
      assert Floki.attribute(dom, "button", "disabled") == ["disabled"]
    end

    test "enables the 'join quiz' button when the ID has exactly four characters", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      html = render_change(view, "form-change", %{"id" => "A123"})
      {:ok, dom} = Floki.parse_document(html)
      assert Floki.attribute(dom, "button", :disabled) == []
    end

    test "redirects to the quiz view when the join button is pressed", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_change(view, "form-change", %{"id" => "A123"})
      render_click(view, "join")
      assert_redirect(view, "/quiz/A123")
    end
  end
end
