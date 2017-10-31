defmodule Fenix.CasteController do
  use Fenix.Web, :controller

  alias Fenix.Caste

  def index(conn, _params) do
    castes = Repo.all(Caste)
    render(conn, "index.json", castes: castes)
  end

  def create(conn, %{"caste" => caste_params}) do
    changeset = Caste.changeset(%Caste{}, caste_params)

    case Repo.insert(changeset) do
      {:ok, caste} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", caste_path(conn, :show, caste))
        |> render("show.json", caste: caste)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    caste = Repo.get!(Caste, id)
    render(conn, "show.json", caste: caste)
  end

  def update(conn, %{"id" => id, "caste" => caste_params}) do
    caste = Repo.get!(Caste, id)
    changeset = Caste.changeset(caste, caste_params)

    case Repo.update(changeset) do
      {:ok, caste} ->
        render(conn, "show.json", caste: caste)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    caste = Repo.get!(Caste, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(caste)

    send_resp(conn, :no_content, "")
  end
end
