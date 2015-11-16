defmodule Relytix.Api.QueryController do
  use Relytix.Web, :controller
  require Logger

  alias Relytix.Query



  def index(conn, params) do
    render conn, params: params
  end
end
