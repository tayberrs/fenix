defmodule Fenix.KhalaController do
  use Fenix.Web, :controller

  alias Fenix.Khala

  def index(conn, _params) do
    khala = Repo.all(Khala)
    render(conn, "index.json", khala: khala)
  end

  def create(conn, %{"khala" => khala_params}) do
    changeset = Khala.changeset(%Khala{}, khala_params)

    case Repo.insert(changeset) do
      {:ok, khala} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", khala_path(conn, :show, khala))
        |> render("show.json", khala: khala)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    khala = Repo.get!(Khala, id)
    render(conn, "show.json", khala: khala)
  end

  def update(conn, %{"id" => id, "khala" => khala_params}) do
    khala = Repo.get!(Khala, id)
    changeset = Khala.changeset(khala, khala_params)

    case Repo.update(changeset) do
      {:ok, khala} ->
        render(conn, "show.json", khala: khala)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    khala = Repo.get!(Khala, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(khala)

    send_resp(conn, :no_content, "")
  end
end
