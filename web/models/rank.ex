defmodule Fenix.Rank do
  use Fenix.Web, :model

  schema "ranks" do
    field :name, :string
    field :hierarchy, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :hierarchy])
    |> validate_required([:name, :hierarchy])
  end
end
