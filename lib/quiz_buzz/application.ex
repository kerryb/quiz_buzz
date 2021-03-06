# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule QuizBuzz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Phoenix.PubSub, name: QuizBuzz.PubSub},
      QuizBuzzWeb.Endpoint,
      QuizBuzz.Core.RandomIDGenerator,
      QuizBuzz.Registry
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QuizBuzz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    QuizBuzzWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
