defmodule Fenix.Entity.Shared.Protoss do
  use Fenix.Entity.Schema
  import Ecto.Changeset

  alias Fenix.Entity.Shared.Embed.ProtossDetail

  schema "protoss" do
    field(:faction, :integer)
    field(:deleted, :boolean, default: false)

    embeds_one(:detail, ProtossDetail)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(protoss, attrs) do
    protoss
    |> cast(attrs, [:faction])
    |> validate_required([:faction])
    |> cast_embed(:detail, required: true)
  end
end
