defmodule Checkboxed.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CheckboxedWeb.Telemetry,
      # Checkboxed.Repo,
      {DNSCluster, query: Application.get_env(:checkboxed, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Checkboxed.PubSub},
      Checkboxed.StateAgent,
      # Start a worker by calling: Checkboxed.Worker.start_link(arg)
      # {Checkboxed.Worker, arg},
      # Start to serve requests, typically the last entry
      CheckboxedWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Checkboxed.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CheckboxedWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
