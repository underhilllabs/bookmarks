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
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
