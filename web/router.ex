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
    get "/bookmarks/archive/:id", BookmarkController, :archive
    get "/tags", TagController, :index
    get "/", BookmarkController, :index
    get "/tags/name/:name", TagController, :name
    get "/b", BookmarkController, :bookmarklet
    get "/goodbye", BookmarkController, :goodbye
    get "/reset_api_token", UserController, :reset_api_token

    resources "/bookmarks", BookmarkController
    #resources "/users", UserController #, only: [:index, :show, :new, :create, :update]
    resources "/users", UserController , only: [:index, :show, :update, :edit ]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  #Other scopes may use custom stacks.
  scope "/api", Bookmarks do
     pipe_through :api
     # /api/bookmarks/recent.json
     get  "/bookmarks/recent.json", ApiBookmarkController, :recent
     # /api/bookmarks/show.json?id=3434
     get  "/bookmarks/show.json", ApiBookmarkController, :show
     # /api/posts/add.json
     post "/posts/add", ApiBookmarkController, :create
     post "/posts/add.json", ApiBookmarkController, :create
  end
end
