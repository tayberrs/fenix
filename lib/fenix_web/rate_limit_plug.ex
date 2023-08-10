defmodule FenixWeb.RateLimitPlug do
  import Plug.Conn

  alias Fenix.Karax

  def init(opts), do: opts

  def call(conn, _opts) do
    with false <- Karax.is_rate_limited?(),
         :ok <- Karax.process_request() do
      conn
    else
      _ ->
        # Return a 429 Too Many Requests response
        conn
        |> put_status(429)
        |> put_resp_header("retry-after", Integer.to_string(5000))
        |> halt()
    end
  end
end
