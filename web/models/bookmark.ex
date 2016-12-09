defmodule Bookmarks.Bookmark do
  use Bookmarks.Web, :model

  @derive {Poison.Encoder, only: [:title, :address, :updated_at, :created_at, :description, :private, :archive_page, :user_id]}

  schema "bookmarks" do
    field :title, :string
    field :address, :string
    field :description, :string
    field :private, :boolean, default: false
    field :archive_page, :boolean, default: false

    many_to_many :tags, Bookmarks.Tag, join_through: Bookmarks.BookmarkTag, on_replace: :delete 
    belongs_to :user, Bookmarks.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:title, :address, :description, :private, :archive_page])
    |> Ecto.Changeset.validate_required([:title, :address])
    |> Ecto.Changeset.put_assoc(:tags, parse_tags(params))
  end
 
  @optional_fields ~w(:user_id)

  def parse_tags(params) do
    (params["tags"] || "")
    |> String.split(",") 
    |> Enum.map(&(String.trim(&1, " ")))
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_tag/1)
  end

  defp get_or_insert_tag(name) do
    Bookmarks.Repo.get_by(Bookmarks.Tag, name: name) || Bookmarks.Repo.insert!(%Bookmarks.Tag{name:  name})
  end

  def tag_link(tagstr) do
    tagstr
    |> Enum.map(&(&1.name))
    |> Enum.map(&("<span><a href='/tags/name/#{&1}'>#{&1}</a></span>"))
    |> Enum.join(" ")
  end
end
