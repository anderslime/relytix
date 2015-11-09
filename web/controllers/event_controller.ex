defmodule Relytix.EventController do
  use Relytix.Web, :controller
  require Logger

  alias Relytix.Event

  def create(conn, params) do
    event_params = sanitized_params(params)
    changeset = Event.changeset(%Event{}, event_params)

    case Relytix.Repo.upsert(Event, changeset) do
      {:ok, event} ->
        conn
        |> put_status(:created)
        |> json %{}
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
  end
end
