defmodule Relytix.Event do
  use Relytix.Web, :model

  schema "events" do
    field :visit_id, Ecto.UUID
    field :name, :string
    field :properties, :map
    field :time, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(visit_id name properties time)
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