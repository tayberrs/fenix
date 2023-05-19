defmodule Fenix.TwilightCouncilTest do
  use Fenix.DataCase

  alias Fenix.TwilightCouncil

  describe "meetings" do
    alias Fenix.Entity.TwilightCouncil.Meeting

    import Fenix.TwilightCouncilFixtures

    @invalid_attrs %{}

    test "list_meetings/0 returns all meetings" do
      meeting = meeting_fixture()
      assert TwilightCouncil.list_meetings() == [meeting]
    end

    test "get_meeting!/1 returns the meeting with given id" do
      meeting = meeting_fixture()
      assert TwilightCouncil.get_meeting!(meeting.id) == meeting
    end

    test "create_meeting/1 with valid data creates a meeting" do
      valid_attrs = %{context: %{name: "name"}}

      assert {:ok, %Meeting{} = meeting} = TwilightCouncil.create_meeting(valid_attrs)
      assert meeting.context.name == "name"
    end

    test "create_meeting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TwilightCouncil.create_meeting(@invalid_attrs)
    end

    test "update_meeting/2 with valid data updates the meeting" do
      meeting = meeting_fixture()
      update_attrs = %{context: %{name: "updated"}}

      assert {:ok, %Meeting{} = meeting} = TwilightCouncil.update_meeting(meeting, update_attrs)
      assert meeting.context.name == "updated"
    end

    test "update_meeting/2 with invalid data returns error changeset" do
      meeting = meeting_fixture()
      assert {:error, %Ecto.Changeset{}} = TwilightCouncil.update_meeting(meeting, @invalid_attrs)
      assert meeting == TwilightCouncil.get_meeting!(meeting.id)
    end

    test "delete_meeting/1 deletes the meeting" do
      meeting = meeting_fixture()
      assert {:ok, %Meeting{}} = TwilightCouncil.delete_meeting(meeting)
      assert_raise Ecto.NoResultsError, fn -> TwilightCouncil.get_meeting!(meeting.id) end
    end

    test "change_meeting/1 returns a meeting changeset" do
      meeting = meeting_fixture()
      assert %Ecto.Changeset{} = TwilightCouncil.change_meeting(meeting)
    end
  end
end
