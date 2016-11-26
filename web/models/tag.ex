defmodule Bookmarks.Tag do
  use Bookmarks.Web, :model

  schema "tags" do
    field :name, :string
    belongs_to :user, Bookmarks.User
    belongs_to :bookmark, Bookmarks.Bookmark

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])    |> validate_required([:name])
  end

  def create_bookmark_tags(id, user_id, %{"tags" => tags}) do
    tags = tags 
         |> String.split(",")
         |> Enum.map(&(String.trim(&1, " ")))
    # manually delete and insert tags
    from(t in Bookmarks.Tag, where: t.bookmark_id == ^id) |> Bookmarks.Repo.delete_all
    Enum.map(tags, fn(tag) -> Bookmarks.Repo.insert(%Bookmarks.Tag{name: tag, user_id: user_id, bookmark_id: id}) end)
  end
end
