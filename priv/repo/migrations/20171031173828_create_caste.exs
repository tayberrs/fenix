defmodule Fenix.Repo.Migrations.CreateCaste do
  use Ecto.Migration

  def change do
    create table(:castes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :text

      timestamps()
    end
  end

  def down do
    drop table(:castes)
  end

end
