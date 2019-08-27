defmodule Rediscl.Query.Api do
	@moduledoc """
		Query api funcs
	"""

	import Rediscl.Query.Util, only: [to_jstring: 2]

	@doc ""
	@spec command(String.t, List.t, Keyword.t) :: List.t
	def command(command, key_or_keys, opts \\ []) do
		[command] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key_or_keys, Keyword.get(opts, :json_opts, []))
			true ->
				if is_list(key_or_keys) do
					key_or_keys
				else
					[key_or_keys]
				end
		end
	end

	@doc ""
	@spec command(String.t) :: List.t
	def command(command) do
		[command]
	end

	@doc ""
	@spec exists(String.t | List.t | Map.t, Keyword.t) :: List.t
	def exists(key, opts \\ []) do
		["EXISTS", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end]
	end

	@doc ""
	@spec append(String.t | List.t | Map.t, String.t | List.t | Map.t, Keyword.t) 
		:: List.t
	def append(key, value, opts \\ []) do
		["APPEND", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec set(String.t | List.t | Map.t, String.t | List.t | Map.t, Keyword.t) 
		:: List.t
	def set(key, value, opts \\ []) do
		["SET", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec set_ex(String.t | List.t | Map.t, Integer.t, 
		String.t | List.t | Map.t | Integer.t, 
		Keyword.t) 
		:: List.t 
	def set_ex(key, second, value, opts \\ []) do
		["SETEX", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, second, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec set_nx(String.t | List.t | Map.t, 
		String.t | List.t | Map.t | Integer.t,
		Keyword.t) 
		:: List.t
	def set_nx(key, value, opts \\ []) do
		["SETNX", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec set_range(String.t | List.t | Map.t, 
		Integer.t, 
		String.t | List.t | Map.t, 
		Keyword.t) 
		:: List.t
	def set_range(key, offset, value, opts \\ []) do
		["SETRANGE", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, offset, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec pset_ex(String.t, Integer.t, String.t | Integer.t, Keyword.t) :: List.t
	def pset_ex(key, milisecond, value, opts \\ []) do
		["PSETEX", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, milisecond, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec get(String.t, Keyword.t) :: List.t
	def get(key, opts \\ []) do
		["GET", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end]
	end

	@doc ""
	@spec get_range(String.t, Integer.t, Integer.t, Keyword.t) :: List.t
	def get_range(key, start, stop, opts \\ []) do
		["GETRANGE", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, start, stop]
	end

	@doc ""
	@spec get_set(String.t, String.t, Keyword.t) :: List.t
	def get_set(key, value, opts \\ []) do
		["GETSET", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec strlen(String.t, Keyword.t) :: List.t
	def strlen(key, opts \\ []) do
		["STRLEN", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end]
	end

	@doc ""
	@spec incr(String.t, Keyword.t) :: List.t
	def incr(key, opts \\ []) do
		["INCR", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end]
	end

	@doc ""
	@spec incr_by(String.t, Integer.t, Keyword.t) :: List.t
	def incr_by(key, value, opts \\ []) do
		["INCRBY", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, value]
	end

	@doc ""
	@spec incr_by_float(String.t, String.t, Keyword.t) :: List.t
	def incr_by_float(key, value, opts \\ []) do
		["INCRBYFLOAT", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, value]
	end

	@doc ""
	@spec decr(String.t, Keyword.t) :: List.t
	def decr(key, opts \\ []) do
		["DECR", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end]
	end

	@doc ""
	@spec decr_by(String.t, Integer.t, Keyword.t) :: List.t
	def decr_by(key, decrement, opts \\ []) do
		["DECRBY", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, decrement]
	end

	@doc ""
	@spec mset(List.t, Keyword.t) :: List.t
	def mset(keys_and_values, opts \\ []) do
		["MSET"] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(keys_and_values, Keyword.get(opts, :json_opts, []))
			true ->
				keys_and_values
		end
	end

	@doc ""
	@spec mset_nx(List.t, Keyword.t) :: List.t
	def mset_nx(keys_and_values, opts \\ []) do
		["MSETNX"] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(keys_and_values, Keyword.get(opts, :json_opts, []))
			true ->
				keys_and_values
		end
	end

	@doc ""
	@spec mget(List.t, Keyword.t) :: List.t
	def mget(keys, opts \\ []) do
		["MGET"] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(keys, Keyword.get(opts, :json_opts, []))
			true ->
				keys
		end
	end

	@doc ""
	@spec del(List.t | Map.t | String.t, Keyword.t) :: List.t
	def del(keys, opts \\ []) do
		del_q(keys, opts)
	end

	defp del_q(keys, opts) when is_list(keys) do
		["DEL"] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(keys, Keyword.get(opts, :json_opts, []))
			true ->
				keys
		end
	end 

	defp del_q(key, opts) when not is_list(key) do
		["DEL", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end]
	end

	@doc ""
	@spec lpush(String.t, List.t, Keyword.t) :: List.t
	def lpush(key, values, opts \\ []) do
		["LPUSH", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(values, Keyword.get(opts, :json_opts, []))
			true ->
				values
		end
	end

	@doc ""
	@spec rpush(String.t, List.t, Keyword.t) :: List.t
	def rpush(key, values, opts \\ []) do
		["RPUSH", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(values, Keyword.get(opts, :json_opts, []))
			true ->
				values
		end
	end

	@doc ""
	@spec lset(String.t, Integer.t, String.t) :: List.t
	def lset(key, index, value, opts \\ []) do
		["LSET", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, index, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec lrange(String.t | List.t | Map.t, 
		Integer.t, 
		Integer.t, 
		Keyword.t) 
		:: List.t
	def lrange(key, start, stop, opts \\ []) do
		["LRANGE", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, start, stop]
	end

	@doc ""
	@spec lrem(String.t, Integer.t, String.t, Keyword.t) :: List.t
	def lrem(key, count, value, opts \\ []) do
		["LREM", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, count, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec sadd(String.t | List.t | Map.t, String.t | List.t | Map.t, Keyword.t) 
		:: List.t
	def sadd(key, values, opts \\ []) do
		["SADD", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end] ++ cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(values, Keyword.get(opts, :json_opts, []))
			true ->
				values
		end
	end

	@doc ""
	@spec scard(String.t | List.t | Map.t, Keyword.t) :: List.t
	def scard(key, opts \\ []) do
		["SCARD", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end]
	end

	@doc ""
	@spec sdiff(List.t, Keyword.t) :: List.t
	def sdiff(keys, opts \\ []) do
		["SDIFF"] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(keys, Keyword.get(opts, :json_opts, []))
			true ->
				keys
		end
	end

	@doc ""
	@spec sdiffstore(String.t | List.t | Map.t, List.t, Keyword.t) :: List.t
	def sdiffstore(key, keys, opts \\ []) do
		["SDIFFSTORE", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(keys, Keyword.get(opts, :json_opts, []))
			true ->
				keys
		end
	end

	@doc ""
	@spec sinter(List.t, Keyword.t) :: List.t
	def sinter(keys, opts \\ []) do
		["SINTER"] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(keys, Keyword.get(opts, :json_opts, []))
			true ->
				keys
		end
	end

	@doc ""
	@spec sinterstore(String.t | Map.t | List.t, List.t, Keyword.t) :: List.t
	def sinterstore(key, keys, opts \\ []) do
		["SINTERSTORE", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(keys, Keyword.get(opts, :json_opts, []))
			true ->
				keys
		end
	end

	@doc ""
	@spec sismember(String.t | List.t | Map.t, String.t, Keyword.t) :: List.t
	def sismember(key, value, opts \\ []) do
		["SISMEMBER", cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_key, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec smembers(String.t | List.t | Map.t, Keyword.t) :: List.t
	def smembers(key, opts \\ []) do
		["SMEMBERS", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end]
	end

	@doc ""
	@spec smove(String.t | List.t | Map.t, 
		String.t | List.t | Map.t, 
		String.t | List.t | Map.t, 
		Keyword.t) :: List.t
	def smove(key_one, key_two, value, opts \\ []) do
		["SMOVE", cond do
			Keyword.get(opts, :jsonable, false) == true and
			(Keyword.get(opts, :encode_key, false) == true or
				Keyword.get(opts, :encode_multiple_keys, false) == true) ->
				to_jstring(key_one, Keyword.get(opts, :json_opts, []))
			true ->
				key_one
		end, cond do
			Keyword.get(opts, :jsonable, false) == true and
			(Keyword.get(opts, :encode_key_two, false) == true or
				Keyword.get(opts, :encode_multiple_keys, false) == true) ->
				to_jstring(key_two, Keyword.get(opts, :json_opts, []))
			true ->
				key_two
		end, cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(value, Keyword.get(opts, :json_opts, []))
			true ->
				value
		end]
	end

	@doc ""
	@spec spop(String.t | List.t | Map.t, Integer.t | nil, Keyword.t) :: List.t
	def spop(key, count \\ nil, opts \\ []) do
		if is_nil(count) do
			["SPOP", cond do
				Keyword.get(opts, :jsonable, false) == true ->
					to_jstring(key, Keyword.get(opts, :json_opts, []))
				true ->
					key
			end]
		else
			["SPOP", cond do
				Keyword.get(opts, :jsonable, false) == true ->
					to_jstring(key, Keyword.get(opts, :json_opts, []))
				true ->
					key
			end, count]
		end
	end

	# @doc ""
	# @spec spop(String.t | List.t | Map.t, Keyword.t) :: List.t
	# def spop(key, opts \\ []) do
	# 	["SPOP", cond do
	# 		Keyword.get(opts, :jsonable, false) == true ->
	# 			@json_library.encode!(key, Keyword.get(opts, :json_opts, []))
	# 		true ->
	# 			key
	# 	end]
	# end

	@doc ""
	@spec srandmember(String.t | List.t | Map.t, Integer.t | nil, Keyword.t) 
		:: List.t
	def srandmember(key, count \\ nil, opts \\ []) do
		srandmember_q(key, count, opts)
	end

	defp srandmember_q(key, count, opts) when is_nil(count) do
		["SRANDMEMBER", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end]
	end

	defp srandmember_q(key, count, opts) do
		["SRANDMEMBER", cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end, count]
	end

	@doc ""
	@spec srem(String.t | List.t | Map.t, 
		String.t | List.t | Map.t, 
		Keyword.t) 
		:: List.t
	def srem(key, value_or_values, opts \\ []) do
		["SREM", cond do
				Keyword.get(opts, :jsonable, false) == true and
				Keyword.get(opts, :encode_key, false) == true ->
					to_jstring(key, Keyword.get(opts, :json_opts, []))
				true ->
					key
			end] ++ cond do
				Keyword.get(opts, :jsonable, false) == true ->
					to_jstring(value_or_values, Keyword.get(opts, :json_opts, []))
				true ->
					value_or_values
			end
	end

	@doc ""
	@spec sscan(String.t | Integer.t | List.t | Map.t, List.t, Keyword.t) 
		:: List.t
	def sscan(key, values, opts \\ []) do
		["SSCAN", if is_integer(key) do
			key
		else
			cond do
				Keyword.get(opts, :jsonable, false) == true and
				Keyword.get(opts, :encode_key, false) == true ->
					to_jstring(key, Keyword.get(opts, :json_opts, []))
				true ->
					key
			end
		end] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(values, Keyword.get(opts, :json_opts, []))
			true ->
				values
		end
	end

	@doc ""
	@spec sunion(List.t, Keyword.t) :: List.t
	def sunion(keys, opts \\ []) do
		["SUNION"] ++ cond do
			Keyword.get(opts, :jsonable, false) == true ->
				to_jstring(keys, Keyword.get(opts, :json_opts, []))
			true ->
				keys
		end
	end

	@doc ""
	@spec sunionstore(String.t | List.t | Map.t, List.t, Keyword.t) :: List.t
	def sunionstore(key, keys, opts \\ []) do
		["SUNIONSTORE", cond do
			Keyword.get(opts, :jsonable, false) == true and
			(Keyword.get(opts, :encode_key, false) == true or
				Keyword.get(opts, :encode_multiple_keys, false) == true) ->
				to_jstring(key, Keyword.get(opts, :json_opts, []))
			true ->
				key
		end] ++ cond do
			Keyword.get(opts, :jsonable, false) == true and
			Keyword.get(opts, :encode_multiple_keys, false) == true ->
				to_jstring(keys, Keyword.get(opts, :json_opts, []))
			true ->
				keys
		end
	end
end