defmodule BookmarksWeb.ApiBookmarkController do
  use BookmarksWeb, :controller
  #plug :authenticate when action in [:edit, :new, :update, :create, :delete, :bookmarklet]

  import Ecto.Query
  alias BookmarksWeb.Bookmark

  defp archive_url(url, user_id, id) do
    Task.async fn ->
      Archiver.archive(url, user_id, id)
    end
  end

  def all(conn, params) do
    all = from(b in Bookmark,
              where: [private: false],
              order_by: [desc: b.updated_at])
            |> preload(:user)
            |> preload(:tags)
            |> Repo.all()
    json conn, all
  end
  def recent(conn, params) do

    page = from(b in Bookmark, 
                where: [private: false], 
                # ecto 2.1
                # or_where: [user_id: conn.assigns.current_user.id],
                order_by: [desc: b.updated_at])
              |> preload(:user)
              |> preload(:tags)
              |> Repo.paginate(params) 
    json conn, page
  end

  def show(conn, %{"id" => id}) do
    bookmark = Repo.get!(Bookmark, id)
              |> Repo.preload(:user)
              |> Repo.preload(:tags)
    json conn, bookmark 
  end

  def create(conn, params) do
    hash = params
    u = Repo.get! BookmarksWeb.User, hash["user_id"]
    if hash["token"] == u.api_token do
      params = %{params | "private" => (hash["private"] > 0)}
      is_archived = (hash["is_archived"] > 0)
      tags = params["tag_list"]
      params = Map.put(params, "description", hash["desc"])
      params = Map.put(params, "tags", tags)
      params = Map.put(params, "archive_page", is_archived)
      # this is not loading if bookmark exists
      case Repo.get_by(Bookmark, %{user_id: u.id, address: hash["url"]}) do
        nil ->
          bookmark = %Bookmark{user_id: u.id, address: hash["url"]} 
                     |> Repo.preload(:tags)
          bc = Bookmark.changeset(bookmark, params)
          bookmark = Repo.insert!(bc)
          if bookmark.archive_page == true do
            archive_url bookmark.address, bookmark.user_id, bookmark.id
          end
        bookmark ->
          bookmark = Repo.preload(bookmark, :tags)
          bc = Bookmark.changeset(bookmark, params)
          Repo.update(bc)
          if bookmark.archive_page == true do
            archive_url bookmark.address, bookmark.user_id, bookmark.id
          end
      end
      json conn, %{}
    end
  end
end
