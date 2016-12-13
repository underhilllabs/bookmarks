defmodule Bookmarks.ApiBookmarkController do
  use Bookmarks.Web, :controller
  #plug :authenticate when action in [:edit, :new, :update, :create, :delete, :bookmarklet]

  alias Bookmarks.Bookmark

  def create(conn, params) do
    hash = params
    u = Repo.get! Bookmarks.User, hash["user_id"]
    if hash["token"] == u.api_token do
      params = %{params | "private" => (hash["private"] > 0)}
      is_archived = (hash["is_archived"] > 0)
      tags = params["tag_list"]
      params = Map.put(params, "tags", tags)
      params = Map.put(params, "archive_page", is_archived)
      # this is not loading if bookmark exists
      case Repo.get_by(Bookmark, %{user_id: u.id, address: hash["url"]}) do
        nil ->
          bookmark = %Bookmark{user_id: u.id, address: hash["url"]} 
                     |> Repo.preload(:tags)
          bc = Bookmark.changeset(bookmark, params)
          Repo.insert(bc)
        bookmark ->
          IO.puts "already exists"
          bookmark = Repo.preload(bookmark, :tags)
          bc = Bookmark.changeset(bookmark, params)
          Repo.update(bc)
      end
      conn
      |> redirect(to: bookmark_path(conn, :index))
    end
  end
end
