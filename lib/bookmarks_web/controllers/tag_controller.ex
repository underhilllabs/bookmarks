defmodule Bookmarks.TagController do
  use Bookmarks.Web, :controller

  alias Bookmarks.Tag
  alias Bookmarks.BookmarkTag
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    tags_count = from(t in Tag,
                      join: bt in BookmarkTag, on: bt.tag_id == t.id,
                      select: [t.name, count(bt.tag_id)],
                      group_by: t.name,
                      limit: 50,
                      order_by: [desc: count(bt.tag_id), asc: bt.tag_id])
                 |> Repo.all
    render(conn, "index.html", tags_count: tags_count)
  end

  def name(conn, params) do
    %{"name" => name} = params
    page = from(b in Bookmarks.Bookmark,
                    join: bt in BookmarkTag, on: b.id == bt.bookmark_id,
                    join: t in Tag, on: t.id == bt.tag_id,
                    where: t.name == ^name,
                    order_by: [desc: b.updated_at],
                    preload: [:tags, :user])
                |> Repo.paginate(params) 
    render conn, "name.html", 
      page: page,
      name: name,
      bookmarks: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
  end
end
