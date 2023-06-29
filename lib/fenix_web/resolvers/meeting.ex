defmodule FenixWeb.Resolvers.Meeting do
  alias Fenix.TwilightCouncil
  alias Fenix.Entity.TwilightCouncil.{Meeting, ProtossMeeting}

  alias FenixWeb.Resolvers.Shared

  def all_meetings(_root, _args, _info) do
    {:ok, TwilightCouncil.list_meetings()}
  end

  def get_meeting(_root, %{meeting_id: meeting_id}, _info) do
    with {:ok, id} <- Shared.uuid_from_string(meeting_id),
         schema when not is_nil(schema) <- TwilightCouncil.get_meeting_with_attendees(id) do
      attendees = meeting_attendees(schema)
      {:ok, Map.put(schema, :attendees, attendees)}
    else
      _ ->
        {:error, "invalid argument"}
    end
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

  def meeting_attendees(%Meeting{protoss_meetings: pms}) do
    Enum.map(pms, fn %{protoss: p, capacity: c} ->
      %{
        capacity: "#{c}",
        protoss: p
      }
    end)
  end
end
