defmodule QuizBuzzWeb.QuizLiveJsTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature
  import Wallaby.Query, only: [button: 1, text_field: 1]

  @name_field text_field("name")
  @save_button button("Save")

  feature "prompts for player name if one is not saved", %{session: session} do
    session
    |> visit("/")
    |> assert_has(@name_field)
  end

  feature "remembers player name between sessions", %{session: session} do
    session
    |> visit("/")
    |> fill_in(@name_field, with: "Alice")
    |> click(@save_button)
    |> assert_text("Alice")
    |> visit("/")
    |> assert_text("Alice")
  end
end
