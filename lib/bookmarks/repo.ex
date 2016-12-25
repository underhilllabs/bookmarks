defmodule Bookmarks.Repo do
  use Ecto.Repo, otp_app: :bookmarks
  use Scrivener, page_size: 20
end
