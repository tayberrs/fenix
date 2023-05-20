defmodule Fenix.Repo.Migrations.CreateMeetings do
  @moduledoc """
  Held within the twilight council.
  """

  use Ecto.Migration

  def up do
    create table(:meetings, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:start_time, :utc_datetime, null: false)
      add(:context, :jsonb)
      add(:intent, :jsonb)
      add(:outcome, :jsonb)

      add(:history, :jsonb)

      add(:deleted, :boolean, null: false)
      timestamps(type: :utc_datetime)
    end

    create(index(:meetings, [:deleted], where: "deleted = false"))

    execute(
      "CREATE INDEX meetings_context_category ON meetings USING GIN ((context->'category') jsonb_path_ops);"
    )

    execute(
      "CREATE INDEX meetings_context_type ON meetings USING GIN ((context->'type') jsonb_path_ops);"
    )

    execute(
      "CREATE INDEX meetings_intent_category ON meetings USING GIN ((intent->'category') jsonb_path_ops);"
    )

    execute(
      "CREATE INDEX meetings_intent_type ON meetings USING GIN ((intent->'type') jsonb_path_ops);"
    )
  end

  def down do
    drop table(:meetings)
  end
end
