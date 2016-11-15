defmodule Bookmarks.Repo.Migrations.AddNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
      add :fullname, :string
    end
  end
end
