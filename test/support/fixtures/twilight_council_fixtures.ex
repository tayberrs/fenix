defmodule Fenix.TwilightCouncilFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fenix.TwilightCouncil` context.
  """

  @doc """
  Generate a meeting.
  """
  def meeting_fixture(attrs \\ %{}) do
    {:ok, meeting} =
      attrs
      |> Enum.into(%{
        context: %{name: "name"}
      })
      |> Fenix.TwilightCouncil.create_meeting()

    meeting
  end
end
