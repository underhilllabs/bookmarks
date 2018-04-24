defmodule BookmarksWeb.BookmarkTag do
  use BookmarksWeb, :model

  schema "bookmarks_tags" do
    belongs_to :bookmark, BookmarksWeb.Bookmark
    belongs_to :tag, BookmarksWeb.Tag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:bookmark_id, :tag_id])
    |> validate_required([:bookmark_id, :tag_id])
  end
end
