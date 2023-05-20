defmodule FenixWeb.ProtossLive.FormComponent do
  use FenixWeb, :live_component

  alias Fenix.Shared

  @impl true
  def update(%{protoss: protoss} = assigns, socket) do
    changeset = Shared.change_protoss(protoss)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"protoss" => protoss_params}, socket) do
    changeset =
      socket.assigns.protoss
      |> Shared.change_protoss(protoss_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"protoss" => protoss_params}, socket) do
    save_protoss(socket, socket.assigns.action, protoss_params)
  end

  defp save_protoss(socket, :edit, protoss_params) do
    case Shared.update_protoss(socket.assigns.protoss, protoss_params) do
      {:ok, _protoss} ->
        {:noreply,
         socket
         |> put_flash(:info, "Protoss updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_protoss(socket, :new, protoss_params) do
    case Shared.create_protoss(protoss_params) do
      {:ok, _protoss} ->
        {:noreply,
         socket
         |> put_flash(:info, "Protoss created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
