defmodule Streambug.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      StreambugWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:streambug, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Streambug.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Streambug.Finch},
      # Start a worker by calling: Streambug.Worker.start_link(arg)
      # {Streambug.Worker, arg},
      # Start to serve requests, typically the last entry
      StreambugWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Streambug.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StreambugWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
