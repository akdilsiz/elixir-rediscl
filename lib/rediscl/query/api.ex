defmodule Rediscl.Query.Api do
	@moduledoc """
		Query api funcs
	"""

	@doc false
	@spec set(String.t, String.t) :: List.t
	def set(key, value) do
		["SET", key, value]
	end

	@doc false
	@spec get(String.t) :: List.t
	def get(key) do
		["GET", key]
	end

	@doc false
	@spec mset(List.t) :: List.t
	def mset(key_and_values) do
		["MSET"] ++ key_and_values
	end

	@doc false
	@spec mget(List.t) :: List.t
	def mget(keys) do
		["MGET"] ++ keys
	end

	@doc false
	@spec del(List.t) :: List.t
	def del(keys) do
		["DEL"] ++ keys
	end

	@doc false
	@spec lpush(String.t, List.t) :: List.t
	def lpush(key, values) do
		["LPUSH", key] ++ values
	end

	@doc false
	@spec rpush(String.t, List.t) :: List.t
	def rpush(key, values) do
		["RPUSH", key] ++ values
	end

	@doc false
	@spec lset(String.t, Integer.t, String.t) :: List.t
	def lset(key, index, value) do
		["LSET", key, index, value]
	end

	@doc false
	@spec lrange(String.t, Integer.t, Integer.t) :: List.t
	def lrange(key, start, stop) do
		["LRANGE", key, start, stop]
	end

	@doc false
	@spec lrem(String.t, Integer.t, String.t) :: List.t
	def lrem(key, count, value) do
		["LREM", key, count, value]
	end
end