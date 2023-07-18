defmodule Fenix.Arbiter do
  @moduledoc """
  Operational support :D
  """

  use GenServer

  @tc :twlight_council
  @tc_na :twlight_countil_meeting_attendees

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def add_twlight_council_attendee(id) do
    GenServer.call(__MODULE__, {:add_tc_attendee, id})
  end

  def remove_twlight_council_attendee(id) do
    GenServer.call(__MODULE__, {:remove_tc_attendee, id})
  end

  def get_twilight_council_current_attendees() do
    with {:ok, attendees} <- lookup(@tc, @tc_na) do
      attendees
    else
      _ ->
        # TODO: error logging
        []
    end
  end

  def init(_) do
    support_twlight_council()
    {:ok, nil}
  end

  @doc """
  No go for concurency for these operations.
  """
  def handle_call({:add_tc_attendee, id}, _from, _state) do
    with {:ok, attendees} <- lookup(@tc, @tc_na),
         false <- id in attendees do
      :ets.insert(@tc, {@tc_na, attendees ++ [id]})
      {:reply, :ok, :new_state}
    else
      _ ->
        # TODO: error logging
        {:reply, :error, :old}
    end
  end

  def handle_call({:remove_tc_attendee, id}, _from, _state) do
    with {:ok, attendees} <- lookup(@tc, @tc_na),
         true <- id in attendees do
      :ets.insert(@tc, {@tc_na, attendees -- [id]})
      {:reply, :ok, :new_state}
    else
      _ ->
        # TODO: error logging
        {:reply, :error, :old}
    end
  end

  defp support_twlight_council() do
    :ets.new(@tc, [:named_table])
    :ets.insert(@tc, {@tc_na, []})
  end

  defp lookup(table, key) do
    case :ets.lookup(table, key) do
      [{^key, value}] -> {:ok, value}
      _ -> :error
    end
  end
end
