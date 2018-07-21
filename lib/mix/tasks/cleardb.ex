defmodule Mix.Tasks.Clearrediscldb do
	@moduledoc """
		Clear keys on tests db
	"""
	use Mix.Task

	import Mix.Rediscl
	
	alias Rediscl
  
  require Logger
  @shortdoc "Clear keys"
  
	def run(_) do
		Logger.configure(level: :info)

    Logger.configure_backend(:console,
                              format: "$time $metadata[$level] $levelpad$message\n")

    Logger.info "== Started Cleardb"

		{:ok, pid} = ensure_started(:rediscl, [])

		{:ok, keys} = Rediscl.Query.command("KEYS", "*")

		if Enum.count(keys) > 0 do
			{:ok, _keys} = Rediscl.Query.del(keys)			
		end

		pid && Rediscl.Superv.stop(pid)

    Logger.info "== Completed Cleardb"
	end
end