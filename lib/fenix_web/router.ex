defmodule FenixWeb.Router do
  use FenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FenixWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug FenixWeb.RateLimitPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FenixWeb do
    pipe_through :browser

    get "/", PageController, :index

    scope "/meetings" do
      live "/", MeetingLive.Index, :index
      live "/new", MeetingLive.Index, :new
      live "/:id", MeetingLive.Show, :show
      live "/:id/edit", MeetingLive.Index, :edit
    end

    scope "/protoss" do
      live "/", ProtossLive.Index, :index
      live "/new", ProtossLive.Index, :new
      live "/:id", ProtossLive.Show, :show
      live "/:id/edit", ProtossLive.Index, :edit
    end

    scope "/lightsout" do
      live "/", LightsOutLive.Board
    end
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: FenixWeb.Schema,
      interface: :simple,
      context: %{pubsub: FenixWeb.Endpoint}
  end

  # Other scopes may use custom stacks.
  # scope "/api", FenixWeb do
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

      live_dashboard "/dashboard", metrics: FenixWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
