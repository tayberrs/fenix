defmodule Fenix.RankController do
  use Fenix.Web, :controller

  alias Fenix.Rank

  def index(conn, _params) do
    ranks = Repo.all(Rank)
    render(conn, "index.json", ranks: ranks)
  end

  def create(conn, %{"rank" => rank_params}) do
    changeset = Rank.changeset(%Rank{}, rank_params)

    case Repo.insert(changeset) do
      {:ok, rank} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", rank_path(conn, :show, rank))
        |> render("show.json", rank: rank)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rank = Repo.get!(Rank, id)
    render(conn, "show.json", rank: rank)
  end

  def update(conn, %{"id" => id, "rank" => rank_params}) do
    rank = Repo.get!(Rank, id)
    changeset = Rank.changeset(rank, rank_params)

    case Repo.update(changeset) do
      {:ok, rank} ->
        render(conn, "show.json", rank: rank)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Fenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rank = Repo.get!(Rank, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(rank)

    send_resp(conn, :no_content, "")
  end
end
