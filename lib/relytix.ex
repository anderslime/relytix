defmodule Relytix do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Relytix.Endpoint, []),
      supervisor(Relytix.ViewModelRegistry, []),
      worker(Relytix.Repo, []),
      # worker(Relytix.ViewModelServer, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Relytix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Relytix.Endpoint.config_change(changed, removed)
    :ok
  end
end
