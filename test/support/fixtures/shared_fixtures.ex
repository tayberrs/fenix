defmodule Fenix.SharedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fenix.Shared` context.
  """

  @doc """
  Generate a protoss.
  """
  def protoss_fixture(attrs \\ %{}) do
    {:ok, protoss} =
      attrs
      |> Enum.into(%{
        faction: 1
      })
      |> Fenix.Shared.create_protoss()

    protoss
  end
end
