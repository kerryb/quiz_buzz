defmodule QuizBuzz.MixProject do
  use Mix.Project

  def project do
    [
      app: :quiz_buzz,
      version: "0.4.1",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: elixirc_options(Mix.env()),
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: preferred_cli_env(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: dialyzer(),
      docs: docs(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {QuizBuzz.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp elixirc_options(:test), do: []
  defp elixirc_options(_env), do: [warnings_as_errors: true]

  defp preferred_cli_env do
    [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.html": :test
    ]
  end

  defp dialyzer do
    [
      plt_add_deps: :app_tree,
      ignore_warnings: "config/dialyzer.ignore-warnings"
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ~w(README.md),
      source_url_pattern: "https://github.com/kerryb/quiz_buzz/blob/master/%{path}#L%{line}"
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:credo, "~> 1.3", only: [:dev, :test]},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.21", only: :dev},
      {:floki, "~> 0.26", only: :test},
      {:hashids, "~> 2.0"},
      {:phoenix, "~> 1.6.0"},
      {:phoenix_live_view, "~> 0.11"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.1"}
    ]
  end
end
