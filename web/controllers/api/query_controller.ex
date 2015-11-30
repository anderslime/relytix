defmodule Relytix.Api.QueryController do
  use Relytix.Web, :controller
  require Logger
  alias Relytix.ViewModelServer

  def show(conn, %{"id" => key}) do
    events = Relytix.EventQueries.by_name(key)
    ViewModelRegistry.ensure_view_model(key)
    {:ok, _} = ViewModelServer.find_or_start(key)
    ViewModelServer.process_events(key, events)
    view_model_data = ViewModelServer.get(key)
    render conn, events: view_model_data
  end
end
