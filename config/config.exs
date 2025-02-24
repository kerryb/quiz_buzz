# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :logger, :console,
  # Configures the endpoint
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :quiz_buzz, QuizBuzzWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xx9Y6r94MW/cBMf+704JlN1jWi/O8nx6x6izqmB2e8jopk4ATDQFk5jajV0FSZfK",
  render_errors: [view: QuizBuzzWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: QuizBuzz.PubSub,
  live_view: [signing_salt: "JIaeHshe"]

config :quiz_buzz, flash_persist_milliseconds: to_timeout(second: 3)

# Configures Elixir's Logger

# Use Jason for JSON parsing in Phoenix

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
