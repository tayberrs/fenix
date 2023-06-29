defmodule FenixWeb.Resolvers.Shared do
  @moduledoc """
  Shared capabilities/necessities to satisfy concerns at the entrypoint.
  """

  alias Ecto.UUID

  def uuid_from_string(string), do: UUID.cast(string)
end
