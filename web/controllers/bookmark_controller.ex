defmodule Bookmarks.BookmarkController do
  use Bookmarks.Web, :controller

  alias Bookmarks.Bookmark
  alias Bookmarks.Tag

  def index(conn, params) do
    page = from(b in Bookmark,order_by: [desc: b.updated_at])
              |> preload(:user)
              |> preload(:tags)
              |> Repo.paginate(params) 
    render conn, "index.html", 
      bookmarks: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
  end

  # get /bookmarks/user/:id
  # Show a user's bookmarks
  def user(conn, params) do
    %{"id" => user_id} = params
    user = Repo.one(from u in Bookmarks.User, where: [id: ^user_id])
    page = from(b in Bookmark, 
              where: b.user_id == ^user_id,
              order_by: [desc: b.updated_at])
              |> preload(:user)
              |> preload(:tags)
              |> Repo.paginate(params) 

    render conn, "user_bookmarks.html", 
      bookmarks: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      user: user
  end

  def new(conn, _params) do
    changeset = Bookmark.changeset(%Bookmark{tags: ""})
                #|> Repo.preload(:tags)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bookmark" => bookmark_params}) do
    tags = Bookmark.get_tags(bookmark_params)
    bookmark = %Bookmark{user_id: conn.assigns.current_user.id} 
    changeset = Bookmark.changeset(bookmark, bookmark_params)

    case Repo.insert(changeset) do
      {:ok, bookmark} ->
        # insert tags with this bookmark and user
        Enum.map(tags, fn(tag) -> Repo.insert(%Tag{name: tag, user_id: conn.assigns.current_user.id, bookmark_id: bookmark.id}) end)
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
              |> Repo.preload(:tags)
    render(conn, "show.html", bookmark: bookmark)
  end

  def edit(conn, %{"id" => id}) do
    bookmark = Repo.get!(user_bookmarks(conn.assigns.current_user), id)
            |> Repo.preload([:tags])
    %Bookmark{tags: tags} = bookmark
    tagstr = tags
            |> Enum.map(&(&1.name))
            |> Enum.join(", ")
    changeset = Bookmark.changeset(bookmark, %{tags: tagstr})
    render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bookmark" => bookmark_params}) do
    bookmark = Repo.get!(Bookmark, id)
    changeset = Bookmark.changeset(bookmark, bookmark_params)
    Bookmarks.Tag.create_bookmark_tags(bookmark.id, conn.assigns.current_user.id, bookmark_params)

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
