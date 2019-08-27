defmodule Rediscl.Query.Util do
	@moduledoc """
		Rediscl Utilizations
	"""

	@json_library Application.get_env(:rediscl, :json_library, Jason)

	@doc ""
	@spec to_jstring(Any.t, Keyword.t) :: Any.t
	def to_jstring(params, opts \\ []) do
		jstring(params, opts)
	end
	
	defp jstring(params, opts) when is_list(params) do
		Enum.map(params, 
			&cond do
				is_binary(&1) ->
					&1
				is_integer(&1) ->
					&1
				true ->
					@json_library.encode!(&1, opts)
			end)
	end

	defp jstring(params, opts) when is_map(params) do
		@json_library.encode!(params, opts)
	end

	defp jstring(params, _opts) do
		params
	end

	@doc ""
	@spec to_any(Any.t, Keyword.t) :: Any.t
	def to_any(params, opts \\ []) do
		any(params, opts)
	end

	defp any(params, opts) when is_list(params) do
		Enum.map(params, 
			&@json_library.decode!(&1, opts))
	end

	defp any(params, opts) do
		@json_library.decode!(params, opts)
	end
end