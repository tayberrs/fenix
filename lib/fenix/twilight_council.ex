defmodule Fenix.TwilightCouncil do
  @moduledoc """
  The TwilightCouncil context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Fenix.Repo

  alias Fenix.Entity.TwilightCouncil.{ProtossMeeting, Meeting}

  @doc """
  Returns the list of meetings.

  ## Examples

      iex> list_meetings()
      [%Meeting{}, ...]

  """
  def list_meetings do
    Repo.all(Meeting)
  end

  @doc """
  Gets a single meeting.

  Raises `Ecto.NoResultsError` if the Meeting does not exist.

  ## Examples

      iex> get_meeting!(123)
      %Meeting{}

      iex> get_meeting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meeting!(id), do: Repo.get!(Meeting, id)

  @doc """
  Creates a meeting.

  ## Examples

      iex> create_meeting(%{field: value})
      {:ok, %Meeting{}}

      iex> create_meeting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meeting(attrs \\ %{}) do
    %Meeting{}
    |> Meeting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meeting.

  ## Examples

      iex> update_meeting(meeting, %{field: new_value})
      {:ok, %Meeting{}}

      iex> update_meeting(meeting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meeting(%Meeting{} = meeting, attrs) do
    meeting
    |> Meeting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meeting.

  ## Examples

      iex> delete_meeting(meeting)
      {:ok, %Meeting{}}

      iex> delete_meeting(meeting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meeting(%Meeting{} = meeting) do
    Repo.delete(meeting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meeting changes.

  ## Examples

      iex> change_meeting(meeting)
      %Ecto.Changeset{data: %Meeting{}}

  """
  def change_meeting(%Meeting{} = meeting, attrs \\ %{}) do
    Meeting.changeset(meeting, attrs)
  end

  def create_protoss_meeting(attrs \\ %{}) do
    %ProtossMeeting{}
    |> ProtossMeeting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Only creator can add and only to the meeting they created.
  """
  def add_protoss_to_meeting(
        %ProtossMeeting{meeting_id: meeting_id, capacity: :creator},
        protoss_id
      ) do
    %ProtossMeeting{}
    |> ProtossMeeting.changeset(%{
      protoss_id: protoss_id,
      capacity: :attendee,
      meeting_id: meeting_id
    })
    |> Repo.insert()
  end

  def create_meeting_with_attendees(meeting_attr, creator_id, attendee_ids) do
    multi =
      Multi.new()
      |> Multi.run(:create_meeting, fn _, _ -> create_meeting(meeting_attr) end)
      |> Multi.run(:creator, fn _, %{create_meeting: %{id: meeting_id}} ->
        create_protoss_meeting(%{
          protoss_id: creator_id,
          meeting_id: meeting_id,
          capacity: :creator
        })
      end)

    attendee_ids
    |> Enum.reduce({multi, 1}, fn a, {m, c} ->
      {Multi.run(m, "attendee_#{c}", fn _, %{create_meeting: %{id: meeting_id}} ->
         create_protoss_meeting(%{protoss_id: a, meeting_id: meeting_id, capacity: :attendee})
       end), c + 1}
    end)
    |> elem(0)
    |> Repo.transaction()
  end
end
