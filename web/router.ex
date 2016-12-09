defmodule Bookmarks.Router do
  use Bookmarks.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Bookmarks.Auth, repo: Bookmarks.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Bookmarks do
    pipe_through :browser # Use the default browser stack
    get "/bookmarks/user/:id", BookmarkController, :user
    get "/tags", TagController, :index
    get "/", BookmarkController, :index
    get "/tags/name/:name", TagController, :name

    resources "/bookmarks", BookmarkController
    resources "/users", UserController #, only: [:index, :show, :new, :create, :update]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Bookmarks do
  #   pipe_through :api
  # end
end
