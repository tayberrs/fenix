defmodule Fenix.Entity.TwilightCouncil.Embed.MeetingContext do
  use Fenix.Entity.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:category, :integer)
    field(:type, :integer)
    field(:end_time, :integer)
    field(:name, :string)
    field(:description, :string)
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:category, :type, :name, :description])
    |> validate_required([:name])
  end
end
