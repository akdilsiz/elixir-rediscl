defmodule Mix.Rediscl do
	@moduledoc false
	alias Rediscl.Superv
	
	@doc false
  @spec ensure_started(module, Keyword.t) :: {:ok, pid} | no_return
	def ensure_started(client, opts) do
		IO.warn "`Mix.Rediscl.ensure_started/2` deprecated", Macro.Env.stacktrace(__ENV__)
		{:ok, _started} = Application.ensure_all_started(client)

		pool_size = Keyword.get(opts, :pool_size, 1)
		case Superv.start_link([name: {:local, Rediscl},
                      worker_module: __MODULE__.Work,
                      size: pool_size,
                      max_overflow: 1]) do
    	{:ok, pid} ->
    		{:ok, pid}
  		{:error, {:already_started, pid}} ->
				{:ok, pid}
			{:error, error} ->
				{:error, error}             	
    end
	end
end