defmodule FenixWeb.MeetingLive.Show do
  use FenixWeb, :live_view

  alias Phoenix.Socket.Broadcast

  alias Fenix.{Shared, TwilightCouncil}
  alias FenixWeb.Presence

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    attendee = Shared.get_available_protoss()
    Phoenix.PubSub.subscribe(Fenix.PubSub, "tcm:#{id}")
    Presence.track(self(), "tcm:#{id}", attendee.detail.name, %{})

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:meeting, TwilightCouncil.get_meeting!(id))
     |> assign(:attendee, attendee)
     |> assign(:attendees, [])}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    updated =
      "tcm:#{socket.assigns.meeting.id}"
      |> Presence.list()
      |> Enum.map(fn {k, _} -> k end)

    {:noreply, socket |> assign(:attendees, updated)}
  end

  defp page_title(:show), do: "Show Meeting"
  defp page_title(:edit), do: "Edit Meeting"
end
