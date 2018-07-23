use Mix.Config

config :logger, level: :warn

config :rediscl,
	host: "localhost",
	port: 6380,
	password: "",
	database: 0,
	pool: 5,
	timeout: 15_000
