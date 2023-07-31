defmodule Fenix.Probius do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def make_request(from, to) do
    GenServer.cast(__MODULE__, {:queue_request, from, to})
  end

  def init(opts) do
    {:ok,
     %{
       limit: opts.limit,
       rate: 0,
       interval: opts.interval,
       requests: :queue.new(),
       request_count: 0,
       repeat: nil
     }, {:continue, :init}}
  end

  def handle_continue(:init, state) do
    {:noreply, %{state | repeat: repeat(state.interval)}}
  end

  def handle_cast({:queue_request, from, to}, %{rate: 10} = state) do
    updated = :queue.in({from, to}, state.requests)
    size = state.request_count + 1

    {:noreply, %{state | requests: updated, request_count: size}}
  end

  def handle_cast({:queue_request, from, to}, state) do
    process_request(from, to)
    {:noreply, %{state | rate: state.rate + 1}}
  end

  def handle_info(:rate_refresh, %{request_count: 0} = state) do
    IO.inspect("refreshed with 0")
    IO.inspect(state)

    rate = if state.rate < state.limit, do: state.rate, else: state.rate - 1
    {:noreply, %{state | rate: rate, repeat: repeat(state.interval)}}
  end

  def handle_info(:rate_refresh, state) do
    IO.inspect("refreshed")
    IO.inspect(state)

    {{:value, {from, to}}, queue} = :queue.out(state.requests)

    process_request(from, to)

    {:noreply,
     %{
       state
       | requests: queue,
         request_count: state.request_count - 1,
         repeat: repeat(state.interval)
     }}
  end

  def handle_info({ref, _result}, state) do
    IO.inspect("demonitored process: completed MAKE REQUEST call")
    Process.demonitor(ref, [:flush])

    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, reason}, state) do
    IO.inspect("process down: #{reason}")

    {:noreply, state}
  end

  defp process_request(from, to) do
    x = :rand.uniform(1000)
    IO.inspect("started processing request : #{x}")

    Task.Supervisor.async_nolink(Fenix.TaskSupervisor, fn ->
      {from_module, from_function, from_args} = from
      {to_module, to_function} = to

      resp = apply(from_module, from_function, from_args)
      apply(to_module, to_function, [resp])

      IO.inspect("finished processing request : #{x}")
    end)
  end

  defp repeat(interval) do
    Process.send_after(self(), :rate_refresh, interval)
  end

  def mock(x) do
    :timer.sleep(4000)
    "mock function executed: #{x}"
  end
end
