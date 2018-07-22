use Mix.Config

config :logger, level: :warn

config :rediscl,
	host: "127.0.0.1",
	port: 6379,
	password: "1093d67d7ad14ef76ee1a7b7dbd2027bb2b865a2237366948762ae9bedae802c",
	database: 10,
	pool: 5,
	timeout: 15_000
