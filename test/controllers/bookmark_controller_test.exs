defmodule Bookmarks.BookmarkControllerTest do
  use Bookmarks.ConnCase

  alias Bookmarks.Bookmark
  @valid_attrs %{address: "some content", archive_page: true, description: "some content", private: true, title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, bookmark_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing bookmarks"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, bookmark_path(conn, :new)
    assert html_response(conn, 200) =~ "New bookmark"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, bookmark_path(conn, :create), bookmark: @valid_attrs
    assert redirected_to(conn) == bookmark_path(conn, :index)
    assert Repo.get_by(Bookmark, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, bookmark_path(conn, :create), bookmark: @invalid_attrs
    assert html_response(conn, 200) =~ "New bookmark"
  end

  test "shows chosen resource", %{conn: conn} do
    bookmark = Repo.insert! %Bookmark{}
    conn = get conn, bookmark_path(conn, :show, bookmark)
    assert html_response(conn, 200) =~ "Show bookmark"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, bookmark_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bookmark = Repo.insert! %Bookmark{}
    conn = get conn, bookmark_path(conn, :edit, bookmark)
    assert html_response(conn, 200) =~ "Edit bookmark"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    bookmark = Repo.insert! %Bookmark{}
    conn = put conn, bookmark_path(conn, :update, bookmark), bookmark: @valid_attrs
    assert redirected_to(conn) == bookmark_path(conn, :show, bookmark)
    assert Repo.get_by(Bookmark, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bookmark = Repo.insert! %Bookmark{}
    conn = put conn, bookmark_path(conn, :update, bookmark), bookmark: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit bookmark"
  end

  test "deletes chosen resource", %{conn: conn} do
    bookmark = Repo.insert! %Bookmark{}
    conn = delete conn, bookmark_path(conn, :delete, bookmark)
    assert redirected_to(conn) == bookmark_path(conn, :index)
    refute Repo.get(Bookmark, bookmark.id)
  end
end
