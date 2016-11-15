defmodule Bookmarks.Router do
  use Bookmarks.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Bookmarks do
    pipe_through :browser # Use the default browser stack
    resources "/bookmarks", BookmarkController
    resources "/tags", TagController

    get "/hello/:name", HelloController, :bigwig
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Bookmarks do
  #   pipe_through :api
  # end
end
