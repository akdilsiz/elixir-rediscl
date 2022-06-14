import Config

config :logger, level: :warn

config :rediscl,
  host: {127, 0, 0, 1},
  port: 6379,
  password: "",
  database: 1,
  pool: 5,
  timeout: 15_000
