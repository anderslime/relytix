defmodule Relytix.VisitController do
  use Relytix.Web, :controller

  plug :fetch_session

  alias Relytix.Visit

  def create(conn, params) do
    IO.inspect conn
    changeset = Visit.changeset(%Visit{}, visit_params(conn, params))

    case Relytix.Repo.upsert(Visit, changeset) do
      {:ok, visit} ->
        conn
        |> put_status(:created)
        |> json %{}
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Relytix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp visit_params(conn, params) do
    params
    |> Map.put("ip", ip_address(conn.remote_ip))
    |> Map.put("id", params["visit_token"])
    |> Map.put("visitor_id", params["visitor_token"])
  end

  defp ip_address(remote_ip) do
    remote_ip
    |> Tuple.to_list
    |> Enum.join "."
  end
end
