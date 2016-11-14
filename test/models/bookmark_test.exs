defmodule Bookmarks.BookmarkTest do
  use Bookmarks.ModelCase

  alias Bookmarks.Bookmark

  @valid_attrs %{address: "some content", archive_page: true, description: "some content", private: true, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bookmark.changeset(%Bookmark{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bookmark.changeset(%Bookmark{}, @invalid_attrs)
    refute changeset.valid?
  end
end
