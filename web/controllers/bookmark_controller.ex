defmodule Bookmarks.BookmarkController do
  use Bookmarks.Web, :controller

  alias Bookmarks.Bookmark

  def index(conn, _params) do
    bookmarks = Repo.all(Bookmark)
              |> Repo.preload(:user)
    render(conn, "index.html", bookmarks: bookmarks)
  end

  def user(conn, %{"id" => user_id  }) do
    user = Repo.get(Bookmarks.User, user_id)
    bookmarks = Repo.all(user_bookmarks(user))
    render(conn, "index.html", bookmarks: bookmarks)
  end

  def new(conn, _params) do
    changeset = Bookmark.changeset(%Bookmark{})
    render(conn, "new.html", changeset: changeset)
  end

  defp get_tags(params) do
    %{"tag" => tagstr} = params
    tagstr 
    |> String.split(",") 
    |> Enum.map(&(String.trim(&1, " ")))
  end

  def create(conn, %{"bookmark" => bookmark_params}) do
    bookmark = %Bookmark{user_id: conn.assigns.current_user.id} 
    bookmark_params = %{bookmark_params| "tag" => get_tags(bookmark_params)}
    changeset = Bookmark.changeset(bookmark, bookmark_params)

    case Repo.insert(changeset) do
      {:ok, _bookmark} ->
        conn
        |> put_flash(:info, "Bookmark created successfully.")
        |> redirect(to: bookmark_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bookmark = Repo.get!(Bookmark, id)
              |> Repo.preload(:user)
    render(conn, "show.html", bookmark: bookmark)
  end

  def edit(conn, %{"id" => id}) do
    bookmark = Repo.get!(user_bookmarks(conn.assigns.current_user), id)
    changeset = Bookmark.changeset(bookmark)
    render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bookmark" => bookmark_params}) do
    bookmark = Repo.get!(Bookmark, id)
    changeset = Bookmark.changeset(bookmark, bookmark_params)

    case Repo.update(changeset) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Bookmark updated successfully.")
        |> redirect(to: bookmark_path(conn, :show, bookmark))
      {:error, changeset} ->
        render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark = Repo.get!(Bookmark, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bookmark)

    conn
    |> put_flash(:info, "Bookmark deleted successfully.")
    |> redirect(to: bookmark_path(conn, :index))
  end

  defp user_bookmarks(user) do
    assoc(user, :bookmarks)
  end
end
