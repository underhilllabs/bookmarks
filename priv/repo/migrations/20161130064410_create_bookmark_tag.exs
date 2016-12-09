defmodule Bookmarks.Repo.Migrations.CreateBookmarkTag do
  use Ecto.Migration

  def change do
    create table(:bookmarks_tags) do
      add :bookmark_id, references(:bookmarks, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)

      timestamps()
    end
    create index(:bookmarks_tags, [:bookmark_id])
    create index(:bookmarks_tags, [:tag_id])

  end
end
