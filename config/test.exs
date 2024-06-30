import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :logger, level: :warn

config :quiz_buzz, QuizBuzzWeb.Endpoint,
  http: [port: 4002],
  server: false

config :quiz_buzz, flash_persist_milliseconds: 100

# Print only warnings and errors during test
