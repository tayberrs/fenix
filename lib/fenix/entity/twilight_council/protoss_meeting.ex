defmodule Fenix.Entity.TwilightCouncil.ProtossMeeting do
  @moduledoc """
  The N:N relationship of protoss and meetings.
  """

  use Fenix.Entity.Schema
  import Ecto.Changeset

  alias Fenix.Entity.Shared.Protoss
  alias Fenix.Entity.TwilightCouncil.Meeting

  schema "protoss_meetings" do
    field(:deleted, :boolean, default: false)

    belongs_to(:protoss_id, Protoss)
    belongs_to(:meeting_id, Meeting)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:protoss_id, :meeting_id])
    |> validate_required([:protoss_id, :meeting_id])
  end
end
