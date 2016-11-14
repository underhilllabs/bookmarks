defmodule Bookmarks.User do
  use Bookmarks.Web, :model

  schema "users" do
    field :email, :string
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
  end
end
