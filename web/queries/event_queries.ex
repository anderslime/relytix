defmodule Relytix.EventQueries do
  import Ecto.Query
  alias Relytix.Event
  alias Relytix.Repo

  def by_name(name) do
    query = from w in Event,
            where: w.name == ^name,
            select: w
    Repo.all(query)
  end
end
