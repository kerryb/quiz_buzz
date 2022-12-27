defmodule QuizBuzz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      QuizBuzzWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: QuizBuzz.PubSub},
      # Start Finch
      {Finch, name: QuizBuzz.Finch},
      # Start the Endpoint (http/https)
      QuizBuzzWeb.Endpoint
      # Start a worker by calling: QuizBuzz.Worker.start_link(arg)
      # {QuizBuzz.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QuizBuzz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QuizBuzzWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
