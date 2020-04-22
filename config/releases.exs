import Config

config :quiz_buzz, QuizBuzzWeb.Endpoint,
  server: true,
  http: [host: "quizbuzz.kerryb.org", port: {:system, "PORT"}],
  url: [scheme: "https", host: "quizbuzz.kerryb.org", port: 443],
  check_origin: ["//quizbuzz.kerryb.org", "//quizbuzz.gigalixirapp.com"]
