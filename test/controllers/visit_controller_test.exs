defmodule Relytix.VisitControllerTest do
  use Relytix.ConnCase

  alias Relytix.Visit
  @valid_attrs %{ip: "some content", started_at: "2010-04-17 14:00:00", visitor_id: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, visit_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    visit = Repo.insert! %Visit{}
    conn = get conn, visit_path(conn, :show, visit)
    assert json_response(conn, 200)["data"] == %{"id" => visit.id,
      "visitor_id" => visit.visitor_id,
      "ip" => visit.ip,
      "started_at" => visit.started_at}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, visit_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, visit_path(conn, :create), visit: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Visit, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, visit_path(conn, :create), visit: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    visit = Repo.insert! %Visit{}
    conn = put conn, visit_path(conn, :update, visit), visit: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Visit, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    visit = Repo.insert! %Visit{}
    conn = put conn, visit_path(conn, :update, visit), visit: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    visit = Repo.insert! %Visit{}
    conn = delete conn, visit_path(conn, :delete, visit)
    assert response(conn, 204)
    refute Repo.get(Visit, visit.id)
  end
end
