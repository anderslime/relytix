defmodule Relytix.Api.QueryController do
  use Relytix.Web, :controller
  require Logger
  alias Relytix.ViewModelServer
  alias Relytix.ViewModelRegistry

  def show(conn, %{"id" => key}) do
    ViewModelRegistry.ensure_view_model(key)
    view_model_data = ViewModelServer.get(key)
    render conn, events: view_model_data
  end
end
