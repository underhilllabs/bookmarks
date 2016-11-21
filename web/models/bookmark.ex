defmodule Bookmarks.Bookmark do
  use Bookmarks.Web, :model

  schema "bookmarks" do
    field :title, :string
    field :address, :string
    field :description, :string
    field :private, :boolean, default: false
    field :archive_page, :boolean, default: false
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
    #|> Changeset.put_assoc(:user, @current_user)
  end
  
  @optional_fields ~w(:user_id)
end
