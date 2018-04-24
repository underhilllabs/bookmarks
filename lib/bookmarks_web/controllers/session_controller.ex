defmodule BookmarksWeb.SessionController do
  use Bookmarks.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  # this is a login redirected from trying to bookmark page, it will always be a bookmarklet since you can't see add bookmark link when not logged in
  def create(conn, %{"session" => %{"username" => user, "password" => pass}, "orig_address" => address, "orig_title" => title, "orig_popup" => "1"} = params) do
    case Bookmarks.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: bookmark_path(conn, :bookmarklet, address: address, title: title, popup: "1"))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end
  def create(conn, %{"session" => %{"username" => user, "password" => pass}} = params) do
    case Bookmarks.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: bookmark_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Bookmarks.Auth.logout()
    |> redirect(to: bookmark_path(conn, :index))
  end
end
