defmodule StreambugWeb.Router do
  use StreambugWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {StreambugWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StreambugWeb do
    pipe_through :browser

    live "/", IndexLive, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", StreambugWeb do
  #   pipe_through :api
  # end
end
