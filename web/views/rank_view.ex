defmodule Fenix.RankView do
  use Fenix.Web, :view

  def render("index.json", %{ranks: ranks}) do
    %{data: render_many(ranks, Fenix.RankView, "rank.json")}
  end

  def render("show.json", %{rank: rank}) do
    %{data: render_one(rank, Fenix.RankView, "rank.json")}
  end

  def render("rank.json", %{rank: rank}) do
    %{id: rank.id,
      name: rank.name,
      caste_id: rank.caste_id}
  end
end
