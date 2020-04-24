use Mix.Config

config :rediscl,
  host: "127.0.0.1",
  port: 6379,
  password: "",
  database: 0,
  pool: 15,
  timeout: 15_000
