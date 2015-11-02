defmodule Relytix.TestController do
  use Relytix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
