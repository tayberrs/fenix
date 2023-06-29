defmodule FenixWeb.Schema.Meeting do
  use Absinthe.Schema.Notation

  alias FenixWeb.Resolvers.Meeting, as: MeetingResolver

  object :meeting do
    field :id, non_null(:string)
    field :start_time, non_null(:datetime)
    field :context, non_null(:meeting_context), resolve: &MeetingResolver.meeting_context/3
    field :attendees, non_null(list_of(:meeting_attendee))
  end

  object :meeting_context do
    field :type, non_null(:integer)
    field :name, non_null(:string)
    field :description, :string
  end

  object :meeting_attendee do
    field :protoss, non_null(:protoss)
    field :capacity, non_null(:string)
  end
end
