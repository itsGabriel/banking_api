defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug BankingApi.Guardian.Pipeline
    plug Guardian.Plug.EnsureAuthenticated, error_handler: BankingApi.Guardian.ErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankingApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", BankingApiWeb do
    pipe_through :api

    post "/create", SessionController, :create
    post "/login", SessionController, :login
  end

  scope "/api", BankingApiWeb do
    pipe_through [:api, :auth]

    get "/teste", SessionController, :me
  end

  # Other scopes may use custom stacks.
  # scope "/api", BankingApiWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BankingApiWeb.Telemetry
    end
  end
end
