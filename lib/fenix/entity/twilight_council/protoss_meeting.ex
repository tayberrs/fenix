defmodule Fenix.Entity.TwilightCouncil.ProtossMeeting do
  @moduledoc """
  The N:N relationship of protoss and meetings.
  """

  use Fenix.Entity.Schema
  import Ecto.Changeset

  alias Fenix.Entity.Shared.Protoss
  alias Fenix.Entity.TwilightCouncil.Meeting

  schema "protoss_meetings" do
    field(:capacity, Ecto.Enum, values: [creator: 1, attendee: 2])
    field(:deleted, :boolean, default: false)

    belongs_to(:protoss, Protoss)
    belongs_to(:meeting, Meeting)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:protoss_id, :meeting_id, :capacity])
    |> validate_required([:protoss_id, :meeting_id, :capacity])
  end
end
