defmodule Bookmarks.Repo.Migrations.UserApiToken do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :api_token, :string
    end
  end
end
