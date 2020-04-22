import Config

config :quiz_buzz, QuizBuzzWeb.Endpoint,
  server: true,
  http: [host: "quizbuzz.kerryb.org", port: {:system, "PORT"}],
