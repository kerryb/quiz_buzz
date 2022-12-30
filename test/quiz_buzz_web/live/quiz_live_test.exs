defmodule QuizBuzzWeb.QuizLiveTest do
  use QuizBuzzWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "Editing the player's name" do
    test "saves the name when the modal form is submitted", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_hook(view, "edit-name")
      view |> element("form") |> render_submit(%{"name" => "Alice"})
      assert view |> element("h2", "Alice") |> has_element?()
    end

    test "allows the modal to be closed with the cancel button", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_hook(view, "edit-name")
      view |> element("a", "Cancel") |> render_click()
      refute view |> element("form") |> has_element?()
    end

    test "allows the name to be edited", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_hook(view, "edit-name")
      view |> element("form") |> render_submit(%{"name" => "Alice"})

      view |> element("a#edit-name") |> render_click()
      view |> element("form") |> render_submit(%{"name" => "Bob"})
      assert view |> element("h2", "Bob") |> has_element?()
    end
  end
end
