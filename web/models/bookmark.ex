defmodule Bookmarks.Bookmark do
  use Bookmarks.Web, :model

  schema "bookmarks" do
    field :title, :string
    field :address, :string
    field :description, :string
    field :private, :boolean, default: false
    field :archive_page, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :address, :description, :private, :archive_page])
    |> validate_required([:title, :address, :description, :private, :archive_page])
  end
end
