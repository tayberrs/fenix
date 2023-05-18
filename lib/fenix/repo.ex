defmodule Fenix.Repo do
  use Ecto.Repo,
    otp_app: :fenix,
    adapter: Ecto.Adapters.Postgres
end
