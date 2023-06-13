defmodule Fenix.Entity.Shared.Embed.ProtossDetail do
  use Fenix.Entity.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
