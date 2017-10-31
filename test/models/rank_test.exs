defmodule Fenix.RankTest do
  use Fenix.ModelCase

  alias Fenix.Rank

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Rank.changeset(%Rank{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Rank.changeset(%Rank{}, @invalid_attrs)
    refute changeset.valid?
  end
end
