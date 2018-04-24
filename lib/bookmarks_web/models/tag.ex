defmodule BookmarksWeb.Tag do
  use BookmarksWeb, :model

  schema "tags" do
    field :name, :string
    many_to_many :bookmarks, BookmarksWeb.Bookmark, join_through: BookmarksWeb.BookmarkTag

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
