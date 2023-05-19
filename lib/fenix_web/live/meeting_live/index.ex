defmodule FenixWeb.MeetingLive.Index do
  use FenixWeb, :live_view

  alias Fenix.TwilightCouncil
  alias Fenix.Entity.TwilightCouncil.Meeting

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :meetings, list_meetings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Meeting")
    |> assign(:meeting, TwilightCouncil.get_meeting!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Meeting")
    |> assign(:meeting, %Meeting{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Meetings")
    |> assign(:meeting, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    meeting = TwilightCouncil.get_meeting!(id)
    {:ok, _} = TwilightCouncil.delete_meeting(meeting)

    {:noreply, assign(socket, :meetings, list_meetings())}
  end

  defp list_meetings do
    TwilightCouncil.list_meetings()
  end
end
