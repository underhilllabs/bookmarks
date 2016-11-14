defmodule Bookmarks.HelloController do
  use Bookmarks.Web, :controller

  def bigwig(conn, %{"name" => name}) do
    render conn, "bigwig.html", name: name
  end
end
