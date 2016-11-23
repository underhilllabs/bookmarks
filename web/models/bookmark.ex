defmodule Bookmarks.Bookmark do
  use Bookmarks.Web, :model

  schema "bookmarks" do
    field :title, :string
    field :address, :string
    field :description, :string
    field :private, :boolean, default: false
    field :archive_page, :boolean, default: false
    #many_to_many :tags, Tag, join_through: Bookmarks.BookmarkTag
    has_many :tags, Bookmarks.Tag
    belongs_to :user, Bookmarks.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :address, :description, :private, :archive_page])
    |> cast_assoc(:tags)
    |> validate_required([:title, :address, :private, :archive_page])
    #|> put_assoc(:tags)
  end
  
  @optional_fields ~w(:user_id)

  def get_tags(params) do
    %{"tag" => tagstr} = params
    tagstr 
    |> String.split(",") 
    |> Enum.map(&(String.trim(&1, " ")))
  end

  def create_tags(params) do
    get_tags(params)
    |> Enum.map(&(Bookmarks.Tag.create(&1)))
  end

  def insert_tag(name, user_id, bookmark_id) do
    tag_changeset = Bookmarks.Tag.changeset(%Bookmarks.Tag{}, %{name: name, user_id: user_id, bookmark_id: bookmark_id})
    Repo.insert(Bookmarks.Tag, tag_changeset)
  end
end
