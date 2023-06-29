defmodule FenixWeb.Resolvers.Protoss do
  alias Fenix.Shared
  alias Fenix.Entity.Shared.Protoss

  def all_protoss(_root, _args, _info) do
    {:ok, Shared.list_protoss()}
  end

  def warp_in_protoss(_, args, _) do
    Map.put(args, :detail, %{name: args.name})
    |> Shared.create_protoss()
  end

  def protoss_detail(%Protoss{detail: detail}, _, _), do: {:ok, detail}

  def protoss_faction(%Protoss{faction: faction}, _, _), do: {:ok, "#{faction}"}
end
