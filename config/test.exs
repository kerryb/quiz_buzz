import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :quiz_buzz, QuizBuzzWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "1OIJBJS9hOauUqN4ekJ9L0NjHV9p29KgUWAaLSzwZgzvehw7qBR+Z1CuqG98w7vw",
  server: true

# In test we don't send emails.
config :quiz_buzz, QuizBuzz.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
