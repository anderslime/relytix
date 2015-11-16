defmodule Relytix.Router do
  use Relytix.Web, :router

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

  scope "/", Relytix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/test", TestController, :index
    get "/events", EventController, :index
    resources "/dashboard", DashboardController
  end


  # Other scopes may use custom stacks.
  scope "/api", Relytix.Api do
    pipe_through :api
    resources "/events", EventController, except: [:new, :edit]
    resources "/visits", VisitController, except: [:new, :edit]
    resources "/queries", QueryController
  end
end
