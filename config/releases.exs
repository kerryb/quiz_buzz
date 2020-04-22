import Config

config :quiz_buzz, QuizBuzzWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
