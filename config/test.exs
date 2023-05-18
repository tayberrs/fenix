import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :fenix, Fenix.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "fenix_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fenix, FenixWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "m2MTK3CoINOVLiArFd3+rj3N41jS+6yIKH6wS5ZKuKz1SaTTz36Y2Ih1JDIo6r1A",
  server: false

# In test we don't send emails.
config :fenix, Fenix.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
