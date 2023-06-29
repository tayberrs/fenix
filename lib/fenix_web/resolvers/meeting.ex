defmodule FenixWeb.Resolvers.Meeting do
  alias Fenix.TwilightCouncil
  alias Fenix.Entity.TwilightCouncil.{Meeting, ProtossMeeting}

  def all_meetings(_root, _args, _info) do
    {:ok, TwilightCouncil.list_meetings()}
  end

  def create_meeting(
        _,
        %{
          creator_protoss_id: creator,
          attendee_protoss_ids: attendees,
          name: meeting_name,
          type: meeting_type
        },
        _
      ) do
    %{
      type: meeting_type,
      context: %{name: meeting_name}
    }
    |> TwilightCouncil.create_meeting_with_attendees(creator, attendees)
    |> case do
      {:ok, multi} ->
        attendees =
          multi
          |> Enum.filter(fn {_, v} -> v.__struct__ == ProtossMeeting end)
          |> Enum.map(fn {_, pm} ->
            %{protoss: %{id: pm.protoss_id}, capacity: "#{pm.capacity}"}
          end)

        {:ok, Map.put(multi.create_meeting, :attendees, attendees)}

      error ->
        error
    end
  end

  def meeting_context(%Meeting{context: context}, _, _), do: {:ok, context}
end
