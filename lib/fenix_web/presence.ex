defmodule FenixWeb.Presence do
  use Phoenix.Presence,
    otp_app: :fenix,
    pubsub_server: Fenix.PubSub
end
