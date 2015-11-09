defmodule Relytix.EventController do
  use Relytix.Web, :controller

  alias Relytix.Event

  def create(conn, event_params) do
    changeset = Event.changeset(%Event{}, event_params)

    case Repo.insert(changeset) do
      {:ok, event} ->
        conn
        |> put_status(:created)
        |> render("show.json", event: event)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Relytix.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
