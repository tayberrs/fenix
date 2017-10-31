defmodule Fenix.Khala do
  use Fenix.Web, :model

  schema "khala" do
    field :name, :string
    belongs_to :rank, Fenix.Rank

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
