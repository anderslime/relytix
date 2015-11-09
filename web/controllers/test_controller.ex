defmodule Relytix.TestController do
  use Relytix.Web, :controller

  plug :put_layout, "test_app.html"

  def index(conn, _params) do
    render conn, "index.html"
  end
end
