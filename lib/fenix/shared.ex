defmodule Fenix.Shared do
  @moduledoc """
  The Shared context.
  """

  import Ecto.Query, warn: false
  alias Fenix.Repo

  alias Fenix.Entity.Shared.Protoss

  @doc """
  Returns the list of protoss.

  ## Examples

      iex> list_protoss()
      [%Protoss{}, ...]

  """
  def list_protoss do
    Repo.all(Protoss)
  end

  @doc """
  Gets a single protoss.

  Raises `Ecto.NoResultsError` if the Protoss does not exist.

  ## Examples

      iex> get_protoss!(123)
      %Protoss{}

      iex> get_protoss!(456)
      ** (Ecto.NoResultsError)

  """
  def get_protoss!(id), do: Repo.get!(Protoss, id)

  @doc """
  This is actually domain logic instead of a data concern but for now leaving it here and should
  move when we actually do domain expansion.

  Available here means when not already participating in a meeting atm ..
  """
  def get_available_protoss() do
    Protoss
    |> order_by(fragment("RANDOM()"))
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Creates a protoss.

  ## Examples

      iex> create_protoss(%{field: value})
      {:ok, %Protoss{}}

      iex> create_protoss(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_protoss(attrs \\ %{}) do
    %Protoss{}
    |> Protoss.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a protoss.

  ## Examples

      iex> update_protoss(protoss, %{field: new_value})
      {:ok, %Protoss{}}

      iex> update_protoss(protoss, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_protoss(%Protoss{} = protoss, attrs) do
    protoss
    |> Protoss.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a protoss.

  ## Examples

      iex> delete_protoss(protoss)
      {:ok, %Protoss{}}

      iex> delete_protoss(protoss)
      {:error, %Ecto.Changeset{}}

  """
  def delete_protoss(%Protoss{} = protoss) do
    Repo.delete(protoss)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking protoss changes.

  ## Examples

      iex> change_protoss(protoss)
      %Ecto.Changeset{data: %Protoss{}}

  """
  def change_protoss(%Protoss{} = protoss, attrs \\ %{}) do
    Protoss.changeset(protoss, attrs)
  end
end
