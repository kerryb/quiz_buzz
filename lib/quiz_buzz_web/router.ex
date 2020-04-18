defmodule QuizBuzzWeb.Router do
  use QuizBuzzWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {QuizBuzzWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", QuizBuzzWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/quiz/:quiz_id", QuizLive
    live "/quizmaster", QuizmasterLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", QuizBuzzWeb do
  #   pipe_through :api
  # end
end
