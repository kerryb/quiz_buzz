import Config

config :quiz_buzz, QuizBuzzWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "quizbuzz.kerryb.org", port: 443],
  check_origin: ["//quizbuzz.kerryb.org", "//quizbuzz.gigalixirapp.com"]
