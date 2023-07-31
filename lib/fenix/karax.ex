defmodule Fenix.Karax do
  @moduledoc """
  Another workhorse :D
  """

  use GenServer

  @rate_limiter :phoenix_rate_limit

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Read should be fast and going to bypass and go straight to ets.
  """
  def is_rate_limited?() do
    [{_, bool}] = :ets.lookup(@rate_limiter, :is_rate_limited)
    bool
  end

  def process_request() do
    GenServer.call(__MODULE__, :process_request)
  end

  def init(opts) do
    {:ok, %{limit: opts.limit, interval: opts.interval, refresh: nil}, {:continue, :init}}
  end

  def handle_continue(:init, state) do
    :ets.new(@rate_limiter, [:named_table])
    :ets.insert(@rate_limiter, {:rate_limit, {0, state.limit}})
    :ets.insert(@rate_limiter, {:is_rate_limited, false})

    {:noreply, %{state | refresh: refresh(state.interval)}}
  end

  def handle_info(:rate_refresh, state) do
    :ets.insert(@rate_limiter, {:is_rate_limited, false})
    [{_, {rate, limit}}] = :ets.lookup(@rate_limiter, :rate_limit)

    if rate > 0 do
      :ets.insert(@rate_limiter, {:rate_limit, {rate - 1, limit}})
      IO.inspect("rate refreshed to: #{rate - 1}")
    end

    {:noreply, %{state | refresh: refresh(state.interval)}}
  end

  def handle_call(:process_request, _from, state) do
    with [{_, true}] <- :ets.lookup(@rate_limiter, :is_rate_limited) do
      {:reply, :rate_limited, state}
    else
      _ ->
        [{_, {rate, limit}}] = :ets.lookup(@rate_limiter, :rate_limit)

        if rate < limit do
          :ets.insert(@rate_limiter, {:rate_limit, {rate + 1, limit}})
          {:reply, :ok, state}
        else
          :ets.insert(@rate_limiter, {:is_rate_limited, true})
          {:reply, :rate_limited, %{state | refresh: refresh(state.interval)}}
        end
    end
  end

  defp refresh(interval) do
    Process.send_after(self(), :rate_refresh, interval)
  end
end
