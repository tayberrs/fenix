defmodule FenixWeb.ProtossLive.Index do
  use FenixWeb, :live_view

  alias Fenix.Shared
  alias Fenix.Entity.Shared.Protoss

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :protoss_collection, list_protoss())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Protoss")
    |> assign(:protoss, Shared.get_protoss!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Protoss")
    |> assign(:protoss, %Protoss{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Protoss")
    |> assign(:protoss, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    protoss = Shared.get_protoss!(id)
    {:ok, _} = Shared.delete_protoss(protoss)

    {:noreply, assign(socket, :protoss_collection, list_protoss())}
  end

  defp list_protoss do
    Shared.list_protoss()
  end
end
