defmodule Relytix.EventController do
  use Relytix.Web, :controller

  alias Relytix.Event

  def create(conn, event_params) do
    params = sanitized_params(event_params)
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

  defp sanitized_params(params) do
    params
    |> Map.put("time", date_from_unix_timestamp(params["time"]))
  end

  defp date_from_unix_timestamp(time) when is_float(time) do
    round(time) |> date_from_unix_timestamp
  end
  defp date_from_unix_timestamp(time) do
    time
    |> Relytix.UnixTimestamp.from_timestamp
    |> Timex.Date.from
  end
end
