defmodule Fenix.Entity.TwilightCouncil.Embed.MeetingContext do
  use Fenix.Entity.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:category, :integer)
    field(:type, :integer)
    field(:start_time, :integer)
    field(:end_time, :integer)
    field(:name, :string)
    field(:description, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:category, :type, :start_time, :name, :description])
    |> validate_required([:category, :type, :start_time, :name])
  end
end
