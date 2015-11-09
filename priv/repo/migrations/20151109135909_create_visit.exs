defmodule Relytix.Repo.Migrations.CreateVisit do
  use Ecto.Migration

  def change do
    create table(:visits, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :visitor_id, :uuid
      add :ip, :string
      add :started_at, :datetime

      timestamps
    end

  end
end
