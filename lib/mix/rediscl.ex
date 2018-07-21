defmodule Mix.Rediscl do
	@moduledoc false
	alias Rediscl.Superv
	@doc false
  @spec ensure_started(module, Keyword.t) :: {:ok, pid} | no_return
	def ensure_started(client, _opts) do
		{:ok, _started} = Application.ensure_all_started(client)

		case Superv.start_link([name: {:local, Rediscl},
                      worker_module: __MODULE__.Work,
                      size: 1,
                      max_overflow: @pool_max_overflow]) do
    	{:ok, pid} ->
    		{:ok, pid}
  		{:error, {:already_started, pid}} ->
				{:ok, pid}
			{:error, error} ->
				{:error, error}             	
    end
	end
end