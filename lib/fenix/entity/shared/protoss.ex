defmodule Fenix.Entity.Shared.Protoss do
  use Fenix.Entity.Schema
  import Ecto.Changeset

  alias Fenix.Entity.Shared.Embed.ProtossDetail

  schema "protoss" do
    field(:faction, Ecto.Enum,
      values: [khalai: 1, nerazim: 2, purifiers: 3, taldarim: 4, daelaam: 5]
    )

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
