defmodule Relytix.ViewModelRegistry do
  use Supervisor
  alias Relytix.ViewModelServer

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def ensure_view_model(key) do
    Supervisor.start_child(__MODULE__, [key])
  end

  def init(:ok) do
    supervise(
      [worker(Relytix.ViewModelServer, [])],
      strategy: :simple_one_for_one
    )
  end
end
