defmodule Relytix.EventControllerTest do
  use Relytix.ConnCase

  alias Relytix.Event
  @valid_attrs %{name: "some content", properties: %{}, time: "2010-04-17 14:00:00", visit_id: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Event, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
