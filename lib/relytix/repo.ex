defmodule Relytix.Repo do
  use Ecto.Repo, otp_app: :relytix

  def upsert(model, changeset) do
    Dict.get(changeset.changes, :id, :no_id)
    |> upsert_on_id(model, changeset)
  end

  defp upsert_on_id(:no_id, _, changeset), do: {:error, changeset}
  defp upsert_on_id(id, model, changeset) do
    __MODULE__.get(model, id)
    |> upsert_on_get_result(changeset)
  end

  defp upsert_on_get_result(nil, changeset) do
    __MODULE__.insert(changeset)
  end
  defp upsert_on_get_result(result, _), do: {:ok, result}
end
