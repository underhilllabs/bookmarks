defmodule Bookmarks.Tag do
  use Bookmarks.Web, :model

  schema "tags" do
    field :name, :string
    many_to_many :bookmarks, Bookmarks.Bookmark, join_through: Bookmarks.BookmarkTag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

end
