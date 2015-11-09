defmodule Relytix.VisitController do
  use Relytix.Web, :controller

  alias Relytix.Visit

  def create(conn, visit_params) do
    changeset = Visit.changeset(%Visit{}, visit_params)

    case Repo.insert(changeset) do
      {:ok, visit} ->
        conn
        |> put_status(:created)
        |> render("show.json", visit: visit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Relytix.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
