defmodule Fenix.KhalaView do
  use Fenix.Web, :view

  def render("index.json", %{khala: khala}) do
    %{data: render_many(khala, Fenix.KhalaView, "khala.json")}
  end

  def render("show.json", %{khala: khala}) do
    %{data: render_one(khala, Fenix.KhalaView, "khala.json")}
  end

  def render("khala.json", %{khala: khala}) do
    %{id: khala.id,
      name: khala.name,
      rank_id: khala.rank_id}
  end
end
