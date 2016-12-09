defmodule Bookmarks.BookmarkTag do
  use Bookmarks.Web, :model

  schema "bookmarks_tags" do
    belongs_to :bookmark, Bookmarks.Bookmark
    belongs_to :tag, Bookmarks.Tag

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
