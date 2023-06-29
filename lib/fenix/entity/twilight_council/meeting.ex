defmodule Fenix.Entity.TwilightCouncil.Meeting do
  @moduledoc """
  For now the start time will just be filled in at creation time, roadmap is to schedule meetings
  in the future.
  """

  use Fenix.Entity.Schema
  import Ecto.Changeset

  alias Fenix.Entity.TwilightCouncil.ProtossMeeting
  alias Fenix.Entity.TwilightCouncil.Embed.MeetingContext

  schema "meetings" do
    field(:start_time, :utc_datetime)
    field(:deleted, :boolean, default: false)

    embeds_one(:context, MeetingContext)

    has_many(:protoss_meetings, ProtossMeeting)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [])
    |> put_change(:start_time, DateTime.utc_now() |> DateTime.truncate(:second))
    |> cast_embed(:context, required: true)
  end
end
