defmodule Bookmarks.BookmarkController do
  use Bookmarks.Web, :controller
  plug :authenticate when action in [:edit, :new, :update, :create, :delete, :bookmarklet]

  alias Bookmarks.Bookmark

  defp archive_url(url, user_id, id) do
    Task.async fn ->
      Archiver.archive(url, user_id, id)
    end
  end

  defp choose_redirect(params) do
    if params["popup"] == "true" do
      :goodbye
    else
      :index
    end
  end

  def index(conn, params) do
    page = from(b in Bookmark, 
                #where: [private: false], 
                # ecto 2.1
                # or_where: [user_id: conn.assigns.current_user.id],
                order_by: [desc: b.updated_at])
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
    changeset = Bookmark.changeset(%Bookmark{}, %{tags: ""})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bookmark" => bookmark_params}) do
    #tags = Bookmark.parse_tags(bookmark_params)
    bookmark = %Bookmark{user_id: conn.assigns.current_user.id} 
    changeset = Bookmark.changeset(bookmark, bookmark_params)

    case Repo.insert(changeset) do
      {:ok, bookmark} ->
        if bookmark.archive_page == true do
          archive_url bookmark.address, bookmark.user_id, bookmark.id
        end
        conn
        |> put_flash(:info, "Bookmark created successfully.")
        |> redirect(to: bookmark_path(conn, choose_redirect(bookmark_params)))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def archive(conn, %{"id" => id}) do
    bookmark = Repo.get!(Bookmark, id)
    render(conn, "archive.html", bookmark: bookmark)
  end

  def show(conn, %{"id" => id}) do
    bookmark = Repo.get!(Bookmark, id)
              |> Repo.preload(:user)
              |> Repo.preload(:tags)
    render(conn, "show.html", bookmark: bookmark)
  end

  def edit(conn, %{"id" => id}) do
    bookmark = Bookmark
              |> preload([:tags])
              |> Repo.get!(id)
    %Bookmark{tags: tags} = bookmark
    tagstr = tags |> Enum.map(&(&1.name)) |> Enum.join(", ")
    changeset = Bookmark.changeset(bookmark, %{tags: tagstr})
    render(conn, "edit.html", bookmark: bookmark, tagstr: tagstr, changeset: changeset)
  end

  def bookmarklet(conn, params) do
    %{"address" => address} = params
    title = params["title"]
    case Repo.get_by(Bookmark, address: address) do
      :nil ->
        IO.puts "sad trombone for #{title}"
        bookmark = %Bookmark{address: address, title: title}
        changeset = Bookmark.changeset(bookmark, %{tags: ""})
        render(conn, "bookmarklet_new.html", bookmark: bookmark, changeset: changeset)
      bookmark ->
        bookmark = bookmark |> Repo.preload(:tags)
        IO.puts "Found IT"
        %Bookmark{tags: tags} = bookmark
        tagstr = tags |> Enum.map(&(&1.name)) |> Enum.join(", ")
        changeset = Bookmark.changeset(bookmark, %{tags: tagstr})
        render(conn, "bookmarklet_edit.html", bookmark: bookmark, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "bookmark" => bookmark_params}) do
    bookmark = Repo.get!(Bookmark, id) |> Repo.preload([:tags])
    changeset = Bookmark.changeset(bookmark, bookmark_params)
    case Repo.update(changeset) do
      {:ok, bookmark} ->
        if bookmark.archive_page == true do
          archive_url bookmark.address, bookmark.user_id, bookmark.id
        end
        conn
        |> put_flash(:info, "Bookmark updated successfully.")
        |> redirect(to: bookmark_path(conn, choose_redirect(bookmark_params)))
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

  def goodbye(conn, _) do
    render(conn, "goodbye.html")
  end

  defp user_bookmarks(user) do
    assoc(user, :bookmarks)
  end
  
  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end
end
