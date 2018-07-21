defmodule Mix.Rediscl do
	@moduledoc false

	@doc false
  @spec ensure_started(module, Keyword.t) :: {:ok, pid} | no_return
	def ensure_started(client, _opts) do
		{:ok, started} = Application.ensure_all_started(:rediscl)

		{:ok, started}
	end
end