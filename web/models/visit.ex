defmodule Relytix.Visit do
  use Relytix.Web, :model

  @primary_key {:id, :binary_id, []}

  schema "visits" do
    field :visitor_id, Ecto.UUID
    field :ip, :string
    field :started_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(visitor_id ip id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
