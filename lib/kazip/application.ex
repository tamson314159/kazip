defmodule Kazip.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      KazipWeb.Telemetry,
      # Start the Ecto repository
      Kazip.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Kazip.PubSub},
      # Start Finch
      {Finch, name: Kazip.Finch},
      # Start the Endpoint (http/https)
      KazipWeb.Endpoint
      # Start a worker by calling: Kazip.Worker.start_link(arg)
      # {Kazip.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kazip.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KazipWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
