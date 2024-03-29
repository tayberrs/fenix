defmodule Fenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Fenix.Repo,
      # Start the Telemetry supervisor
      FenixWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Fenix.PubSub},
      FenixWeb.Presence,
      # Start the Endpoint (http/https)
      FenixWeb.Endpoint,
      {Task.Supervisor, name: Fenix.TaskSupervisor},
      {Fenix.Probius,
       %{
         limit: Application.get_env(:fenix, :rate_limit_max),
         interval: Application.get_env(:fenix, :rate_limit_interval)
       }},
      {Fenix.Karax, %{limit: 10, interval: 5000}}
      # Start a worker by calling: Fenix.Worker.start_link(arg)
      # {Fenix.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
