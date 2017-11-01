defmodule Fenix.Repo.Migrations.CreateRank do
  use Ecto.Migration

  def change do
    create table(:ranks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :text
      add :hierarchy, :integer

      timestamps()
    end
  end

  def down do
    drop table(:ranks)
  end

end
