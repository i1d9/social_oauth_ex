defmodule SocialOauth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SocialOauthWeb.Telemetry,
      SocialOauth.Repo,
      {DNSCluster, query: Application.get_env(:social_oauth, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SocialOauth.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SocialOauth.Finch},
      # Start a worker by calling: SocialOauth.Worker.start_link(arg)
      # {SocialOauth.Worker, arg},
      # Start to serve requests, typically the last entry
      SocialOauthWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SocialOauth.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SocialOauthWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
