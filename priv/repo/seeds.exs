# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fenix.Repo.insert!(%Fenix.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Fenix.DatabaseSeeder do

  alias Fenix.{Repo,Caste,Rank,Khala}

  @archives %{
    :static => %{
      {Caste, [:name]} => [
        ["Judicator"],
        ["Templar"],
        ["Khalai"]
      ]
    },
    :dynamic => %{}
  }

  @doc """
  'Plant' records into the DB based on the rules specified in the @seeds
  By using insert_all, we will have to generate our own stamps & such
  """
  def initiate do
    purify()
    static()
  end

  defp static do
    Enum.each Map.keys(@archives[:static]), fn key = {model, fields} ->
      Enum.each @archives[:static][key], fn v ->
        Repo.insert_all model, [ format_schema(fields, v) ]
      end
    end
  end

  defp purify do
    # possibly a way to get all models via something built in?
    Enum.each [Caste,Rank,Khala], fn m ->
      Repo.delete_all(m)
    end
  end

  defp random_row(model) do
    Repo.all(model) |> Enum.random()
  end

  defp format_schema(fields, values) do
    now = Ecto.DateTime.utc(:usec)
    Enum.zip(fields, values)
      |> Enum.into(%{})
      |> Map.merge(%{:id => _uuid(), :inserted_at => now, :updated_at => now})
  end

  defp _uuid do
    Ecto.UUID.generate
  end

end


alias Fenix.DatabaseSeeder
DatabaseSeeder.initiate()
