defmodule FenixWeb.ProtossLive.Show do
  use FenixWeb, :live_view

  alias Fenix.Shared

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:protoss, Shared.get_protoss!(id))}
  end

  defp page_title(:show), do: "Show Protoss"
  defp page_title(:edit), do: "Edit Protoss"
end
