defmodule Bookmarks.User do
  use Bookmarks.Web, :model

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :username, :string
    field :fullname, :string
    has_many :bookmarks, Bookmarks.Bookmark
    has_many :tags, Bookmarks.Tag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :username, :fullname ])
    |> validate_required([:email, :password])
  end

  def registration_changeset(model, params) do 
    model
    |> changeset(model)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    #|> hashed_password(password)
    |> put_pass_hash()
  end
  
  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
