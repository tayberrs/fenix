defmodule FenixWeb.PageController do
  use FenixWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
