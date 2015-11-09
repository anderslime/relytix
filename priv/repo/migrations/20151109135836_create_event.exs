defmodule Relytix.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :visit_id, :uuid
      add :name, :string
      add :properties, :map
      add :time, :datetime

      timestamps
    end

  end
end
