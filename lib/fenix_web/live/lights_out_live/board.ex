defmodule FenixWeb.LightsOutLive.Board do
  use FenixWeb, :live_view

  def mount(_, _, socket) do
    {:ok, assign(socket, board: generate_board(), won: false)}
  end

  def handle_event("toggle", %{"x" => x, "y" => y}, socket) do
    xv = String.to_integer(x)
    yv = String.to_integer(y)
    board = ordered_board_as_map(socket.assigns.board)

    updated =
      blast_radius(xv, yv)
      |> Enum.reduce(%{}, fn p, r -> Map.put(r, p, !board[p]) end)
      |> then(fn toggled -> Map.merge(board, toggled) end)

    won = won?(updated)
    socket = assign(socket, board: preserve_board_order(updated), won: won)
    if won, do: {:noreply, push_event(socket, "gameover", %{win: won})}, else: {:noreply, socket}
  end

  defp blast_radius(x, y) do
    lx = Kernel.max(0, x - 1)
    rx = Kernel.min(8, x + 1)
    uy = Kernel.max(0, y - 1)
    dy = Kernel.min(8, y + 1)

    [{x, y}, {lx, y}, {rx, y}, {x, uy}, {x, dy}, {lx, uy}, {rx, uy}, {lx, dy}, {rx, dy}]
  end

  defp won?(board),
    do:
      board
      |> Map.values()
      |> Enum.all?(&(!&1))

  defp generate_board() do
    board =
      for x <- 0..8,
          y <- 0..8,
          into: %{},
          do: {{x, y}, false}

    initial =
      Enum.reduce(1..Enum.random(3..9), %{}, fn _, h ->
        x = Enum.random(0..8)
        y = Enum.random(0..8)
        Map.put(h, {x, y}, true)
      end)

    board
    |> Map.merge(initial)
    |> preserve_board_order()
  end

  defp preserve_board_order(board), do: Enum.sort_by(board, fn {k, _} -> k end)

  defp ordered_board_as_map(ordered_board),
    do: Enum.reduce(ordered_board, %{}, fn {k, v}, h -> Map.put(h, k, v) end)
end
