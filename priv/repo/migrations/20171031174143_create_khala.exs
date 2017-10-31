defmodule Fenix.Repo.Migrations.CreateKhala do
  use Ecto.Migration

  def change do
    create table(:khala, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :text
      add :rank_id, references(:ranks, on_delete: :delete_all, type: :uuid)

      timestamps()
    end
    create index(:khala, [:rank_id])
  end

  def down do
    drop table(:khala)
  end

end
