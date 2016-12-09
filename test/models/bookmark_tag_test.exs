defmodule Bookmarks.BookmarkTagTest do
  use Bookmarks.ModelCase

  alias Bookmarks.BookmarkTag

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BookmarkTag.changeset(%BookmarkTag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BookmarkTag.changeset(%BookmarkTag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
