defmodule FenixWeb.MeetingLive.Show do
  use FenixWeb, :live_view

  alias Phoenix.Socket.Broadcast

  alias Fenix.{Arbiter, Shared, TwilightCouncil}
  alias FenixWeb.Presence

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    case Shared.get_available_protoss_for_twlight_council() do
      {:ok, attendee} ->
        Arbiter.add_twlight_council_attendee(attendee.id)
        Phoenix.PubSub.subscribe(Fenix.PubSub, "tcm:#{id}")
        Presence.track(self(), "tcm:#{id}", attendee.id, %{name: attendee.detail.name})

        {:noreply,
         socket
         |> assign(:page_title, page_title(socket.assigns.live_action))
         |> assign(:meeting, TwilightCouncil.get_meeting!(id))
         |> assign(:attendee, attendee)
         |> assign(:attendees, [])}

      :error ->
        {:noreply, push_redirect(socket, to: "/meetings")}
    end
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: %{leaves: leaver}}, socket)
      when leaver != %{} do
    [leaver_id] = Map.keys(leaver)
    Arbiter.remove_twlight_council_attendee(leaver_id)

    updated =
      "tcm:#{socket.assigns.meeting.id}"
      |> Presence.list()
      |> Enum.map(fn {k, v} ->
        [%{name: name}] = v.metas
        {k, name}
      end)

    {:noreply, socket |> assign(:attendees, updated)}
  end

  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    updated =
      "tcm:#{socket.assigns.meeting.id}"
      |> Presence.list()
      |> Enum.map(fn {k, v} ->
        [%{name: name}] = v.metas
        {k, name}
      end)

    {:noreply, socket |> assign(:attendees, updated)}
  end

  defp page_title(:show), do: "Show Meeting"
  defp page_title(:edit), do: "Edit Meeting"
end
