defmodule Fenix.SharedTest do
  use Fenix.DataCase

  alias Fenix.Shared

  describe "protoss" do
    alias Fenix.Entity.Shared.Protoss

    import Fenix.SharedFixtures

    @invalid_attrs %{deleted: nil, faction: nil}

    test "list_protoss/0 returns all protoss" do
      protoss = protoss_fixture()
      assert Shared.list_protoss() == [protoss]
    end

    test "get_protoss!/1 returns the protoss with given id" do
      protoss = protoss_fixture()
      assert Shared.get_protoss!(protoss.id) == protoss
    end

    test "create_protoss/1 with valid data creates a protoss" do
      valid_attrs = %{deleted: true, faction: 1}

      assert {:ok, %Protoss{} = protoss} = Shared.create_protoss(valid_attrs)
      assert protoss.deleted == true
      assert protoss.faction == 1
    end

    test "create_protoss/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shared.create_protoss(@invalid_attrs)
    end

    test "update_protoss/2 with valid data updates the protoss" do
      protoss = protoss_fixture()
      update_attrs = %{deleted: false, faction: 2}

      assert {:ok, %Protoss{} = protoss} = Shared.update_protoss(protoss, update_attrs)
      assert protoss.deleted == false
      assert protoss.faction == 2
    end

    test "update_protoss/2 with invalid data returns error changeset" do
      protoss = protoss_fixture()
      assert {:error, %Ecto.Changeset{}} = Shared.update_protoss(protoss, @invalid_attrs)
      assert protoss == Shared.get_protoss!(protoss.id)
    end

    test "delete_protoss/1 deletes the protoss" do
      protoss = protoss_fixture()
      assert {:ok, %Protoss{}} = Shared.delete_protoss(protoss)
      assert_raise Ecto.NoResultsError, fn -> Shared.get_protoss!(protoss.id) end
    end

    test "change_protoss/1 returns a protoss changeset" do
      protoss = protoss_fixture()
      assert %Ecto.Changeset{} = Shared.change_protoss(protoss)
    end
  end
end
