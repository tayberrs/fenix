defmodule Fenix.KhalaTest do
  use Fenix.ModelCase

  alias Fenix.Khala

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Khala.changeset(%Khala{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Khala.changeset(%Khala{}, @invalid_attrs)
    refute changeset.valid?
  end
end
