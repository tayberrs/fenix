defmodule Fenix.RankControllerTest do
  use Fenix.ConnCase

  alias Fenix.Rank
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, rank_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    rank = Repo.insert! %Rank{}
    conn = get conn, rank_path(conn, :show, rank)
    assert json_response(conn, 200)["data"] == %{"id" => rank.id,
      "name" => rank.name,
      "caste_id" => rank.caste_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, rank_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, rank_path(conn, :create), rank: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Rank, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, rank_path(conn, :create), rank: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    rank = Repo.insert! %Rank{}
    conn = put conn, rank_path(conn, :update, rank), rank: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Rank, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    rank = Repo.insert! %Rank{}
    conn = put conn, rank_path(conn, :update, rank), rank: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    rank = Repo.insert! %Rank{}
    conn = delete conn, rank_path(conn, :delete, rank)
    assert response(conn, 204)
    refute Repo.get(Rank, rank.id)
  end
end
