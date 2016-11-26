defmodule Bookmarks.TagController do
  use Bookmarks.Web, :controller

  alias Bookmarks.Tag
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    tags_count = from(t in Tag, 
                      select: [t.name, count(t.name)], 
                      group_by: t.name,
                      order_by: [desc: count(t.name), asc: t.name]) 
                 |> Repo.all
    render(conn, "index.html", tags_count: tags_count)
  end

  def name(conn, %{"name" => name}) do
    bookmarks = from(b in Bookmarks.Bookmark,
                    join: t in Tag, on: b.id == t.bookmark_id,
                    where: t.name == ^name,
                    order_by: [desc: b.updated_at])
                |> Repo.all
                |> Repo.preload([:tags, :user])
    render(conn, "name.html", name: name, bookmarks: bookmarks)
  end
end
