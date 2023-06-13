defmodule FenixWeb.MeetingLive.FormComponent do
  use FenixWeb, :live_component

  alias Fenix.TwilightCouncil

  @impl true
  def update(%{meeting: meeting} = assigns, socket) do
    changeset = TwilightCouncil.change_meeting(meeting)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"meeting" => meeting_params}, socket) do
    changeset =
      socket.assigns.meeting
      |> TwilightCouncil.change_meeting(meeting_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"meeting" => meeting_params}, socket) do
    save_meeting(socket, socket.assigns.action, meeting_params)
  end

  defp save_meeting(socket, :edit, meeting_params) do
    case TwilightCouncil.update_meeting(socket.assigns.meeting, meeting_params) do
      {:ok, _meeting} ->
        {:noreply,
         socket
         |> put_flash(:info, "Meeting updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_meeting(socket, :new, meeting_params) do
    case TwilightCouncil.create_meeting(meeting_params) do
      {:ok, _meeting} ->
        {:noreply,
         socket
         |> put_flash(:info, "Meeting created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
