defmodule Fenix.CasteView do
  use Fenix.Web, :view

  def render("index.json", %{castes: castes}) do
    %{data: render_many(castes, Fenix.CasteView, "caste.json")}
  end

  def render("show.json", %{caste: caste}) do
    %{data: render_one(caste, Fenix.CasteView, "caste.json")}
  end

  def render("caste.json", %{caste: caste}) do
    %{id: caste.id,
      name: caste.name}
  end
end
