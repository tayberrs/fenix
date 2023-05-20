defmodule Fenix.Repo.Migrations.CreateProtoss do
  use Ecto.Migration

  def up do
    create table(:protoss, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:faction, :integer, null: false)
      add(:detail, :jsonb)

      add(:deleted, :boolean, null: false)
      timestamps(type: :utc_datetime)
    end

    create(index(:protoss, [:deleted], where: "deleted = false"))

    execute("CREATE extension if not exists pg_trgm;")
    execute(
      "CREATE INDEX protoss_detail_name ON protoss USING GIN ((detail->>'name') gin_trgm_ops);"
    )
  end

  def down do
    drop table(:protoss)
  end
end
