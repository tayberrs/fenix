defmodule Fenix.Repo.Migrations.CreateRank do
  use Ecto.Migration

  def change do
    create table(:ranks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :text
      add :caste_id, references(:castes, on_delete: :delete_all, type: :uuid)

      timestamps()
    end
    create index(:ranks, [:caste_id])
  end

  def down do
    drop table(:ranks)
  end

end
