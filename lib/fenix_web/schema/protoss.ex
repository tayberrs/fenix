defmodule FenixWeb.Schema.Protoss do
  use Absinthe.Schema.Notation

  alias FenixWeb.Resolvers.Protoss, as: ProtossResolver

  object :protoss do
    field :id, non_null(:string)
    field :faction, non_null(:string), resolve: &ProtossResolver.protoss_faction/3
    field :detail, non_null(:protoss_detail), resolve: &ProtossResolver.protoss_detail/3
  end

  object :protoss_detail do
    field :name, :string
  end
end
