import Config

config :quiz_buzz, QuizBuzzWeb.Endpoint,
  server: true,
  http: [scheme: :https, host: "quizbuzz.kerryb.org", port: {:system, "PORT"}]
