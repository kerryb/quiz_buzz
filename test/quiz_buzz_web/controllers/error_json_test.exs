defmodule QuizBuzzWeb.ErrorJSONTest do
  use QuizBuzzWeb.ConnCase, async: true

  test "renders 404" do
    assert QuizBuzzWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert QuizBuzzWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
