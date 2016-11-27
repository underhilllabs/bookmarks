defmodule Bookmarks.Bookmark do
  use Bookmarks.Web, :model
  alias Bookmarks.Tag

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
    |> validate_required([:title, :address, :private, :archive_page])
  end
  
  @optional_fields ~w(:user_id)

  
  def get_tags(params) do
    %{"tags" => tagstr} = params
    tagstr 
    |> String.split(",") 
    |> Enum.map(&(String.trim(&1, " ")))
  end

  def create_tags(params) do
    get_tags(params)
    |> Enum.map(&(Bookmarks.Tag.create(&1)))
  end

  def pretty_date(date) do
  end

  def tag_link(tagstr) do
    tagstr
    |> Enum.map(&(&1.name))
    |> Enum.map(&("<span><a href='/tags/name/#{&1}'>#{&1}</a></span>"))
    |> Enum.join(" ")
  end
end
