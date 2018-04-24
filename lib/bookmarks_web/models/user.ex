defmodule BookmarksWeb.User do
  use BookmarksWeb, :model

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :username, :string
    field :fullname, :string
    field :api_token, :string
    has_many :bookmarks, BookmarksWeb.Bookmark
    has_many :tags, BookmarksWeb.Tag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(email password username fullname api_token) )
    |> validate_required([:email, :password])
  end

  def api_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(email password username fullname api_token) )
    |> validate_required([:api_token])
  end

  def registration_changeset(model, params) do 
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
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
end
