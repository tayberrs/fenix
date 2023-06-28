defmodule Fenix.Repo.Migrations.CreateProtossMeetings do
  @moduledoc """
  Concerns of the instance of said protoss and a meeting.
  """

  use Ecto.Migration

  def up do
    create table(:protoss_meetings, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:context, :jsonb)
      add(:meta, :jsonb)

      add(:protoss_id, references(:protoss, type: :uuid, on_delete: :delete_all), null: false)
      add(:meeting_id, references(:meetings, type: :uuid, on_delete: :delete_all), null: false)

      add(:history, :jsonb)
      add(:deleted, :boolean, null: false)
      timestamps(type: :utc_datetime)
    end

    create(index(:protoss_meetings, [:deleted], where: "deleted = false"))
    create(index(:protoss_meetings, [:protoss_id]))
    create(index(:protoss_meetings, [:meeting_id]))

    execute(
      "CREATE UNIQUE INDEX uq_protoss_id_meeting_id ON protoss_meetings (LEAST(protoss_id, meeting_id), GREATEST(protoss_id, meeting_id))"
    )
  end

  def down do
    drop table(:protoss_meetings)
  end
end
