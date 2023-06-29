defmodule FenixWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(FenixWeb.Schema.Meeting)
  import_types(FenixWeb.Schema.Protoss)

  alias FenixWeb.Resolvers.Meeting, as: MeetingResolver
  alias FenixWeb.Resolvers.Protoss, as: ProtossResolver

  query do
    @desc "Get all protoss"
    field :all_protoss, non_null(list_of(non_null(:protoss))) do
      resolve(&ProtossResolver.all_protoss/3)
    end

    @desc "Get all meetings"
    field :all_meetings, non_null(list_of(non_null(:meeting))) do
      resolve(&MeetingResolver.all_meetings/3)
    end
  end

  mutation do
    @desc "Warp in a new protoss"
    field :warp_protoss, :protoss do
      arg(:faction, non_null(:integer))
      arg(:name, non_null(:string))

      resolve(&ProtossResolver.warp_in_protoss/3)
    end

    @desc "Create a new meeting"
    field :create_meeting, :meeting do
      arg(:creator_protoss_id, non_null(:string))
      arg(:attendee_protoss_ids, non_null(list_of(:string)))
      arg(:type, non_null(:integer))
      arg(:name, non_null(:string))

      resolve(&MeetingResolver.create_meeting/3)
    end
  end
end
