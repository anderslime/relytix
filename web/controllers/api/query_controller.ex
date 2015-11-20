defmodule Relytix.Api.QueryController do
  use Relytix.Web, :controller
  require Logger
  alias Relytix.ViewModelServer

  def index(conn, params) do
    events = Relytix.Repo.all(Relytix.Event)
    {:ok, server} = ViewModelServer.start_link
    ViewModelServer.process_events(server, events)
    events = ViewModelServer.get(server)
    render conn, events: events
  end
end
