defmodule BookmarksWeb.UserController do
  use BookmarksWeb, :controller
  plug :authenticate when action in [:edit, :delete, :reset_api_token]

  alias BookmarksWeb.User
  alias BookmarksWeb.Bookmark
  alias BookmarksWeb.BookmarkTag
  alias BookmarksWeb.Tag
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    users = Repo.all(User)
    users = from(u in User,
            join: b in Bookmark, on: b.user_id == u.id,
            select: [u.username, u.id, count(b.user_id)],
            group_by: u.username) |> Repo.all
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    token = SecureRandom.urlsafe_base64
    changeset = User.registration_changeset(%User{api_token: token}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> BookmarksWeb.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    bookmarks = from(b in Bookmark, 
                  where: [user_id: ^id, private: false], 
                  limit: 10,
                  order_by: [desc: b.updated_at])
                |> Repo.all
    tags_count = from(t in Tag,
                      join: bt in BookmarkTag, on: bt.tag_id == t.id,
                      join: b in Bookmark, on: bt.bookmark_id == b.id,
                      join: u in User, on: b.user_id == u.id,
                      select: [t.name, count(bt.tag_id)],
                      where: b.user_id == ^id,
                      group_by: t.name,
                      limit: 10,
                      order_by: [desc: count(bt.tag_id), asc: bt.tag_id])
                 |> Repo.all
    render(conn, "show.html", user: user, bookmarks: bookmarks, tags_count: tags_count)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  # Update the api token for the user
  def reset_api_token(conn, _params) do
    user = conn.assigns.current_user
    token = SecureRandom.urlsafe_base64
    changeset = User.api_changeset(user, %{api_token: token})
    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User API Token updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
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
