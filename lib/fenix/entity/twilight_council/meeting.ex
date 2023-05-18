defmodule Fenix.Entity.TwilightCouncil.Meeting do
  use Fenix.Entity.Schema
  import Ecto.Changeset

  alias Fenix.Entity.TwilightCouncil.Embed.MeetingContext

  schema "meetings" do
    field(:start_time, :utc_datetime)
    embeds_one(:context, MeetingContext)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:start_time])
    |> validate_required([:start_time])
    |> cast_embed(:context, required: true)
  end
end
