defmodule FenixWeb.Schema do
  use Absinthe.Schema
  import_types(FenixWeb.Schema.Protoss)

  alias FenixWeb.Resolvers.Protoss, as: ProtossResolver

  query do
    @desc "Get all protoss"
    field :all_protoss, non_null(list_of(non_null(:protoss))) do
      resolve(&ProtossResolver.all_protoss/3)
    end
  end

  mutation do
    @desc "Warp in a new protoss"
    field :warp_protoss, :protoss do
      arg(:faction, non_null(:integer))
      arg(:name, non_null(:string))

      resolve(&ProtossResolver.warp_in_protoss/3)
    end
  end
end
