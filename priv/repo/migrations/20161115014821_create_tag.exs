defmodule Bookmarks.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :bookmark_id, references(:bookmarks, on_delete: :nothing)

      timestamps()
    end
    create index(:tags, [:user_id])
    create index(:tags, [:bookmark_id])

  end
end
