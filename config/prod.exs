use Mix.Config

config :myapp, Myapp.Endpoint,
  http: [port: "${PORT}"],
  url: [host: "${HOST}", port: "${PORT}"],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: "${SECRET_KEY_BASE}",
  server: true,
  root: "."

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :myapp, Myapp.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "${DB_HOSTNAME}",
  username: "${DB_USERNAME}",
  password: "${DB_PASSWORD}",
  database: "${DB_NAME}",
  pool_size: 20

config :peerage, via: Peerage.Via.Dns,
  dns_name: "myapp-service-headless.default.svc.cluster.local",
  app_name: "myapp",
  interval: 5
