defmodule Bookmarks.Repo.Migrations.CreateBookmark do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :title, :string
      add :address, :string
      add :description, :text
      add :private, :boolean, default: false, null: false
      add :archive_page, :boolean, default: false, null: false

      timestamps()
    end

  end
end
