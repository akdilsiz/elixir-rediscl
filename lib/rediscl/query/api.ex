defmodule Rediscl.Query.Api do
	@moduledoc """
		Query api funcs
	"""

	@doc ""
	@spec command(String.t, List.t) :: List.t
	def command(command, keys) when is_list(keys) do
		[command] ++ keys
	end

	@doc ""
	@spec command(String.t, String.t) :: List.t
	def command(command, key) do
		[command, key]
	end

	@doc ""
	@spec command(String.t) :: List.t
	def command(command) do
		[command]
	end

	@doc ""
	@spec exists(String.t) :: List.t
	def exists(key) do
		["EXISTS", key]
	end

	@doc ""
	@spec append(String.t, String.t) :: List.t
	def append(key, value) do
		["APPEND", key, value]
	end

	@doc ""
	@spec set(String.t, String.t) :: List.t
	def set(key, value) do
		["SET", key, value]
	end

	@doc ""
	@spec set_ex(String.t, Integer.t, String.t | Integer.t) :: 
		List.t 
	def set_ex(key, second, value) do
		["SETEX", key, second, value]
	end

	@doc ""
	@spec set_nx(String.t, String.t | Integer.t) :: List.t
	def set_nx(key, value) do
		["SETNX", key, value]
	end

	@doc ""
	@spec set_range(String.t, Integer.t, String.t) :: List.t
	def set_range(key, offset, value) do
		["SETRANGE", key, offset, value]
	end

	@doc ""
	@spec pset_ex(String.t, Integer.t, String.t | Integer.t) :: List.t
	def pset_ex(key, milisecond, value) do
		["PSETEX", key, milisecond, value]
	end

	@doc ""
	@spec get(String.t) :: List.t
	def get(key) do
		["GET", key]
	end

	@doc ""
	@spec get_range(String.t, Integer.t, Integer.t) :: List.t
	def get_range(key, start, stop) do
		["GETRANGE", key, start, stop]
	end

	@doc ""
	@spec get_set(String.t, String.t) :: List.t
	def get_set(key, value) do
		["GETSET", key, value]
	end

	@doc ""
	@spec strlen(String.t) :: List.t
	def strlen(key) do
		["STRLEN", key]
	end

	@doc ""
	@spec incr(String.t) :: List.t
	def incr(key) do
		["INCR", key]
	end

	@doc ""
	@spec incr_by(String.t, Integer.t) :: List.t
	def incr_by(key, value) do
		["INCRBY", key, value]
	end

	@doc ""
	@spec incr_by_float(String.t, String.t) :: List.t
	def incr_by_float(key, value) do
		["INCRBYFLOAT", key, value]
	end

	@doc ""
	@spec decr(String.t) :: List.t
	def decr(key) do
		["DECR", key]
	end

	@doc ""
	@spec decr_by(String.t, Integer.t) :: List.t
	def decr_by(key, decrement) do
		["DECRBY", key, decrement]
	end

	@doc ""
	@spec mset(List.t) :: List.t
	def mset(key_and_values) do
		["MSET"] ++ key_and_values
	end

	@doc ""
	@spec mset_nx(List.t) :: List.t
	def mset_nx(keys_and_values) do
		["MSETNX"] ++ keys_and_values
	end

	@doc ""
	@spec mget(List.t) :: List.t
	def mget(keys) do
		["MGET"] ++ keys
	end

	@doc ""
	@spec del(List.t) :: List.t
	def del(keys) do
		["DEL"] ++ keys
	end

	@doc ""
	@spec lpush(String.t, List.t) :: List.t
	def lpush(key, values) do
		["LPUSH", key] ++ values
	end

	@doc ""
	@spec rpush(String.t, List.t) :: List.t
	def rpush(key, values) do
		["RPUSH", key] ++ values
	end

	@doc ""
	@spec lset(String.t, Integer.t, String.t) :: List.t
	def lset(key, index, value) do
		["LSET", key, index, value]
	end

	@doc ""
	@spec lrange(String.t, Integer.t, Integer.t) :: List.t
	def lrange(key, start, stop) do
		["LRANGE", key, start, stop]
	end

	@doc ""
	@spec lrem(String.t, Integer.t, String.t) :: List.t
	def lrem(key, count, value) do
		["LREM", key, count, value]
	end

	@doc ""
	@spec sadd(String.t, List.t) :: List.t
	def sadd(key, values) do
		["SADD", key] ++ values
	end

	@doc ""
	@spec scard(String.t) :: List.t
	def scard(key) do
		["SCARD", key]
	end

	@doc ""
	@spec sdiff(List.t) :: List.t
	def sdiff(keys) do
		["SDIFF"] ++ keys
	end

	@doc ""
	@spec sdiffstore(String.t, List.t) :: List.t
	def sdiffstore(key, keys) do
		["SDIFFSTORE", key] ++ keys
	end

	@doc ""
	@spec sinter(List.t) :: List.t
	def sinter(keys) do
		["SINTER"] ++ keys
	end

	@doc ""
	@spec sinterstore(String.t, List.t) :: List.t
	def sinterstore(key, keys) do
		["SINTERSTORE", key] ++ keys
	end

	@doc ""
	@spec sismember(String.t, String.t) :: List.t
	def sismember(key, value) do
		["SISMEMBER", key, value]
	end

	@doc ""
	@spec smembers(String.t) :: List.t
	def smembers(key) do
		["SMEMBERS", key]
	end

	@doc ""
	@spec smove(String.t, String.t, String.t) :: List.t
	def smove(key_one, key_two, value) do
		["SMOVE", key_one, key_two, value]
	end

	@doc ""
	@spec spop(String.t, Integer.t) :: List.t
	def spop(key, count) do
		["SPOP", key, count]
	end

	@doc ""
	@spec spop(String.t) :: List.t
	def spop(key) do
		["SPOP", key]
	end

	@doc ""
	@spec srandmember(String.t, Integer.t) :: List.t
	def srandmember(key, count) do
		["SRANDMEMBER", key, count]
	end

	@doc ""
	@spec srandmember(String.t) :: List.t
	def srandmember(key) do
		["SRANDMEMBER", key]
	end

	@doc ""
	@spec srem(String.t, List.t) :: List.t
	def srem(key, values) when is_list(values) do
		["SREM", key] ++ values
	end

	@doc ""
	@spec srem(String.t, String.t) :: List.t
	def srem(key, value) do
		["SREM", key, value]
	end

	@doc ""
	@spec sscan(String.t | Integer.t, List.t) :: List.t
	def sscan(key, values) do
		["SSCAN", key] ++ values
	end

	@doc ""
	@spec sunion(List.t) :: List.t
	def sunion(keys) do
		["SUNION"] ++ keys
	end

	@doc ""
	@spec sunionstore(String.t, List.t) :: List.t
	def sunionstore(key, keys) do
		["SUNIONSTORE", key] ++ keys
	end
end