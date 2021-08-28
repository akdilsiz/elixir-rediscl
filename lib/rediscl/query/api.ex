defmodule Rediscl.Query.Api do
  @moduledoc """
  	Query api funcs
  """

  import Rediscl.Query.Util, only: [to_jstring: 2]

  @doc ""
  @spec command(String.t(), List.t(), Keyword.t()) :: List.t()
  def command(command, key_or_keys, opts \\ []) do
    [command] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key_or_keys, Keyword.get(opts, :json_opts, []))
      else
        if is_list(key_or_keys) do
          key_or_keys
        else
          [key_or_keys]
        end
      end
  end

  @doc ""
  @spec command(String.t()) :: List.t()
  def command(command) do
    [command]
  end

  @doc ""
  @spec exists(String.t() | List.t() | Map.t(), Keyword.t()) :: List.t()
  def exists(key, opts \\ []) do
    [
      "EXISTS",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  @doc ""
  @spec append(String.t() | List.t() | Map.t(), String.t() | List.t() | Map.t(), Keyword.t()) ::
          List.t()
  def append(key, value, opts \\ []) do
    [
      "APPEND",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec set(String.t() | List.t() | Map.t(), String.t() | List.t() | Map.t(), Keyword.t()) ::
          List.t()
  def set(key, value, opts \\ []) do
    [
      "SET",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec set_ex(
          String.t() | List.t() | Map.t(),
          Integer.t(),
          String.t() | List.t() | Map.t() | Integer.t(),
          Keyword.t()
        ) ::
          List.t()
  def set_ex(key, second, value, opts \\ []) do
    [
      "SETEX",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      second,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec set_nx(
          String.t() | List.t() | Map.t(),
          String.t() | List.t() | Map.t() | Integer.t(),
          Keyword.t()
        ) ::
          List.t()
  def set_nx(key, value, opts \\ []) do
    [
      "SETNX",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec set_range(
          String.t() | List.t() | Map.t(),
          Integer.t(),
          String.t() | List.t() | Map.t(),
          Keyword.t()
        ) ::
          List.t()
  def set_range(key, offset, value, opts \\ []) do
    [
      "SETRANGE",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      offset,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec pset_ex(String.t(), Integer.t(), String.t() | Integer.t(), Keyword.t()) :: List.t()
  def pset_ex(key, milisecond, value, opts \\ []) do
    [
      "PSETEX",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      milisecond,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec get(String.t(), Keyword.t()) :: List.t()
  def get(key, opts \\ []) do
    [
      "GET",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  @doc ""
  @spec get_range(String.t(), Integer.t(), Integer.t(), Keyword.t()) :: List.t()
  def get_range(key, start, stop, opts \\ []) do
    [
      "GETRANGE",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      start,
      stop
    ]
  end

  @doc ""
  @spec get_set(String.t(), String.t(), Keyword.t()) :: List.t()
  def get_set(key, value, opts \\ []) do
    [
      "GETSET",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec strlen(String.t(), Keyword.t()) :: List.t()
  def strlen(key, opts \\ []) do
    [
      "STRLEN",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  @doc ""
  @spec incr(String.t(), Keyword.t()) :: List.t()
  def incr(key, opts \\ []) do
    [
      "INCR",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  @doc ""
  @spec incr_by(String.t(), Integer.t(), Keyword.t()) :: List.t()
  def incr_by(key, value, opts \\ []) do
    [
      "INCRBY",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      value
    ]
  end

  @doc ""
  @spec incr_by_float(String.t(), String.t(), Keyword.t()) :: List.t()
  def incr_by_float(key, value, opts \\ []) do
    [
      "INCRBYFLOAT",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      value
    ]
  end

  @doc ""
  @spec decr(String.t(), Keyword.t()) :: List.t()
  def decr(key, opts \\ []) do
    [
      "DECR",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  @doc ""
  @spec decr_by(String.t(), Integer.t(), Keyword.t()) :: List.t()
  def decr_by(key, decrement, opts \\ []) do
    [
      "DECRBY",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      decrement
    ]
  end

  @doc ""
  @spec mset(List.t(), Keyword.t()) :: List.t()
  def mset(keys_and_values, opts \\ []) do
    ["MSET"] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys_and_values, Keyword.get(opts, :json_opts, []))
      else
        keys_and_values
      end
  end

  @doc ""
  @spec mset_nx(List.t(), Keyword.t()) :: List.t()
  def mset_nx(keys_and_values, opts \\ []) do
    ["MSETNX"] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys_and_values, Keyword.get(opts, :json_opts, []))
      else
        keys_and_values
      end
  end

  @doc ""
  @spec mget(List.t(), Keyword.t()) :: List.t()
  def mget(keys, opts \\ []) do
    ["MGET"] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc ""
  @spec del(List.t() | Map.t() | String.t(), Keyword.t()) :: List.t()
  def del(keys, opts \\ []) do
    del_q(keys, opts)
  end

  defp del_q(keys, opts) when is_list(keys) do
    ["DEL"] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  defp del_q(key, opts) when not is_list(key) do
    [
      "DEL",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  @doc ""
  @spec lpush(String.t(), List.t(), Keyword.t()) :: List.t()
  def lpush(key, values, opts \\ []) do
    [
      "LPUSH",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(values, Keyword.get(opts, :json_opts, []))
      else
        values
      end
  end

  @doc ""
  @spec rpush(String.t(), List.t(), Keyword.t()) :: List.t()
  def rpush(key, values, opts \\ []) do
    [
      "RPUSH",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(values, Keyword.get(opts, :json_opts, []))
      else
        values
      end
  end

  @doc ""
  @spec lset(String.t(), Integer.t(), String.t()) :: List.t()
  def lset(key, index, value, opts \\ []) do
    [
      "LSET",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      index,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec lrange(
          String.t() | List.t() | Map.t(),
          Integer.t(),
          Integer.t(),
          Keyword.t()
        ) ::
          List.t()
  def lrange(key, start, stop, opts \\ []) do
    [
      "LRANGE",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      start,
      stop
    ]
  end

  @doc ""
  @spec lrem(String.t(), Integer.t(), String.t(), Keyword.t()) :: List.t()
  def lrem(key, count, value, opts \\ []) do
    [
      "LREM",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      count,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec sadd(String.t() | List.t() | Map.t(), String.t() | List.t() | Map.t(), Keyword.t()) ::
          List.t()
  def sadd(key, values, opts \\ []) do
    [
      "SADD",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(values, Keyword.get(opts, :json_opts, []))
      else
        values
      end
  end

  @doc ""
  @spec scard(String.t() | List.t() | Map.t(), Keyword.t()) :: List.t()
  def scard(key, opts \\ []) do
    [
      "SCARD",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  @doc ""
  @spec sdiff(List.t(), Keyword.t()) :: List.t()
  def sdiff(keys, opts \\ []) do
    ["SDIFF"] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc ""
  @spec sdiffstore(String.t() | List.t() | Map.t(), List.t(), Keyword.t()) :: List.t()
  def sdiffstore(key, keys, opts \\ []) do
    [
      "SDIFFSTORE",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc ""
  @spec sinter(List.t(), Keyword.t()) :: List.t()
  def sinter(keys, opts \\ []) do
    ["SINTER"] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc ""
  @spec sinterstore(String.t() | Map.t() | List.t(), List.t(), Keyword.t()) :: List.t()
  def sinterstore(key, keys, opts \\ []) do
    [
      "SINTERSTORE",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc ""
  @spec sismember(String.t() | List.t() | Map.t(), String.t(), Keyword.t()) :: List.t()
  def sismember(key, value, opts \\ []) do
    [
      "SISMEMBER",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec smembers(String.t() | List.t() | Map.t(), Keyword.t()) :: List.t()
  def smembers(key, opts \\ []) do
    [
      "SMEMBERS",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  @doc ""
  @spec smove(
          String.t() | List.t() | Map.t(),
          String.t() | List.t() | Map.t(),
          String.t() | List.t() | Map.t(),
          Keyword.t()
        ) :: List.t()
  def smove(key_one, key_two, value, opts \\ []) do
    [
      "SMOVE",
      if Keyword.get(opts, :jsonable, false) and
           (Keyword.get(opts, :encode_key, false) or
              Keyword.get(opts, :encode_multiple_keys, false)) do
        to_jstring(key_one, Keyword.get(opts, :json_opts, []))
      else
        key_one
      end,
      if Keyword.get(opts, :jsonable, false) and
           (Keyword.get(opts, :encode_key_two, false) or
              Keyword.get(opts, :encode_multiple_keys, false)) do
        to_jstring(key_two, Keyword.get(opts, :json_opts, []))
      else
        key_two
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc ""
  @spec spop(String.t() | List.t() | Map.t(), Integer.t() | nil, Keyword.t()) :: List.t()
  def spop(key, count \\ nil, opts \\ []) do
    spop(key, count, opts, :in)
  end

  defp spop(key, nil, opts, :in) do
    [
      "SPOP",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  defp spop(key, count, opts, :in) do
    [
      "SPOP",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      count
    ]
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
  @spec srandmember(String.t() | List.t() | Map.t(), Integer.t() | nil, Keyword.t()) ::
          List.t()
  def srandmember(key, count \\ nil, opts \\ []) do
    srandmember_q(key, count, opts)
  end

  defp srandmember_q(key, count, opts) when is_nil(count) do
    [
      "SRANDMEMBER",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  defp srandmember_q(key, count, opts) do
    [
      "SRANDMEMBER",
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      count
    ]
  end

  @doc ""
  @spec srem(
          String.t() | List.t() | Map.t(),
          String.t() | List.t() | Map.t(),
          Keyword.t()
        ) ::
          List.t()
  def srem(key, value_or_values, opts \\ []) do
    [
      "SREM",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value_or_values, Keyword.get(opts, :json_opts, []))
      else
        value_or_values
      end
  end

  @doc ""
  @spec sscan(String.t() | Integer.t() | List.t() | Map.t(), List.t(), Keyword.t()) ::
          List.t()
  def sscan(key, values, opts \\ []) do
    [
      "SSCAN",
      if is_integer(key) do
        key
      else
        if Keyword.get(opts, :jsonable, false) and
             Keyword.get(opts, :encode_key, false) do
          to_jstring(key, Keyword.get(opts, :json_opts, []))
        else
          key
        end
      end
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(values, Keyword.get(opts, :json_opts, []))
      else
        values
      end
  end

  @doc ""
  @spec sunion(List.t(), Keyword.t()) :: List.t()
  def sunion(keys, opts \\ []) do
    ["SUNION"] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc ""
  @spec sunionstore(String.t() | List.t() | Map.t(), List.t(), Keyword.t()) :: List.t()
  def sunionstore(key, keys, opts \\ []) do
    [
      "SUNIONSTORE",
      if Keyword.get(opts, :jsonable, false) and
           (Keyword.get(opts, :encode_key, false) or
              Keyword.get(opts, :encode_multiple_keys, false)) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ] ++
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_multiple_keys, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc """
    Creates the zadd :eredis query list, based on the given arguments.
  """
  @spec zadd(String.t(), Integer.t(), String.t(), Keyword.t()) :: List.t()
  def zadd(key, score, value, opts \\ []) do
    [
      "ZADD",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      score,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc """
    Creates the zcard :eredis query list, based on the given arguments.
  """
  @spec zcard(String.t(), Keyword.t()) :: List.t()
  def zcard(key, opts \\ []) do
    [
      "ZCARD",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end
    ]
  end

  @doc """
    Creates the zcount :eredis query list, based on the given arguments.
  """
  @spec zcount(String.t(), Integer.t(), Integer.t(), Keyword.t()) :: List.t()
  def zcount(key, min, max, opts \\ []) do
    [
      "ZCOUNT",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      min,
      max
    ]
  end

  @doc """
    Creates the zincrby :eredis query list, based on the given arguments.
  """
  @spec zincrby(String.t(), Integer.t(), String.t(), Keyword.t()) :: List.t()
  def zincrby(key, increment, value, opts \\ []) do
    [
      "ZINCRBY",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      increment,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc """
    Creates the zinter :eredis query list, based on the given arguments.
  """
  @spec zinter(List.t(), Keyword.t()) :: List.t()
  def zinter(keys, opts \\ []) do
    [
      "ZINTER",
      length(keys)
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc """
    Creates the zinterstore :eredis query list, based on the given arguments.
  """
  @spec zinterstore(String.t() | List.t() | Map.t(), List.t(), Keyword.t()) :: List.t()
  def zinterstore(key, keys, opts \\ []) do
    [
      "ZINTERSTORE",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      length(keys)
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc """
    Creates the zlexcount :eredis query list, based on the given arguments.
  """
  @spec zlexcount(String.t(), String.t(), String.t(), Keyword.t()) :: List.t()
  def zlexcount(key, min, max, opts \\ []) do
    [
      "ZLEXCOUNT",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      min,
      max
    ]
  end

  @doc """
    Creates the zrange :eredis query list, based on the given arguments.
  """
  @spec zrange(String.t(), Integer.t(), Integer.t(), Keyword.t()) :: List.t()
  def zrange(key, min, max, opts \\ []) do
    [
      "ZRANGE",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      min,
      max
    ]
  end

  @doc """
    Creates the zrangebylex :eredis query list, based on the given arguments.
  """
  @spec zrangebylex(String.t(), String.t(), String.t(), Keyword.t()) :: List.t()
  def zrangebylex(key, min, max, opts \\ []) do
    [
      "ZRANGEBYLEX",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      min,
      max
    ]
  end

  @doc """
    Creates the zrangebyscore :eredis query list, based on the given arguments.
  """
  @spec zrangebyscore(String.t(), Integer.t(), Integer.t(), Keyword.t()) :: List.t()
  def zrangebyscore(key, min, max, opts \\ []) do
    [
      "ZRANGEBYSCORE",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      min,
      max
    ]
  end

  @doc """
    Creates the zrank :eredis query list, based on the given arguments.
  """
  @spec zrank(String.t(), String.t(), Keyword.t()) :: List.t()
  def zrank(key, value, opts \\ []) do
    [
      "ZRANK",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc """
    Creates the zrem :eredis query list, based on the given arguments.
  """
  @spec zrem(String.t(), String.t(), Keyword.t()) :: List.t()
  def zrem(key, value, opts \\ []) do
    [
      "ZREM",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc """
    Creates the zremrangebylex :eredis query list, based on the given arguments.
  """
  @spec zremrangebylex(String.t(), String.t(), String.t(), Keyword.t()) :: List.t()
  def zremrangebylex(key, min, max, opts \\ []) do
    [
      "ZREMRANGEBYLEX",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      min,
      max
    ]
  end

  @doc """
    Creates the zremrangebyrank :eredis query list, based on the given arguments.
  """
  @spec zremrangebyrank(String.t(), Integer.t(), Integer.t(), Keyword.t()) :: List.t()
  def zremrangebyrank(key, min, max, opts \\ []) do
    [
      "ZREMRANGEBYRANK",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      min,
      max
    ]
  end

  @doc """
    Creates the zremrangebyscore :eredis query list, based on the given arguments.
  """
  @spec zremrangebyscore(String.t(), Integer.t(), Integer.t(), Keyword.t()) :: List.t()
  def zremrangebyscore(key, min, max, opts \\ []) do
    [
      "ZREMRANGEBYSCORE",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      min,
      max
    ]
  end

  @doc """
    Creates the zrevrange :eredis query list, based on the given arguments.
  """
  @spec zrevrange(String.t(), Integer.t(), Integer.t(), Keyword.t()) :: List.t()
  def zrevrange(key, min, max, opts \\ []) do
    [
      "ZREVRANGE",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      min,
      max
    ]
  end

  @doc """
    Creates the zrevrangebylex :eredis query list, based on the given arguments.
  """
  @spec zrevrangebylex(String.t(), String.t(), String.t(), Keyword.t()) :: List.t()
  def zrevrangebylex(key, max, min, opts \\ []) do
    [
      "ZREVRANGEBYLEX",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      max,
      min
    ]
  end

  @doc """
    Creates the zrevrangebyscore :eredis query list, based on the given arguments.
  """
  @spec zrevrangebyscore(String.t(), Integer.t(), Integer.t(), Keyword.t()) :: List.t()
  def zrevrangebyscore(key, max, min, opts \\ []) do
    [
      "ZREVRANGEBYSCORE",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      max,
      min
    ]
  end

  @doc """
    Creates the zrevrank :eredis query list, based on the given arguments.
  """
  @spec zrevrank(String.t(), String.t(), Keyword.t()) :: List.t()
  def zrevrank(key, value, opts \\ []) do
    [
      "ZREVRANK",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc """
    Creates the zscore :eredis query list, based on the given arguments.
  """
  @spec zscore(String.t(), String.t(), Keyword.t()) :: List.t()
  def zscore(key, value, opts \\ []) do
    [
      "ZSCORE",
      if Keyword.get(opts, :jsonable, false) == true and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(value, Keyword.get(opts, :json_opts, []))
      else
        value
      end
    ]
  end

  @doc """
    Creates the zunion :eredis query list, based on the given arguments.
  """
  @spec zunion(List.t(), Keyword.t()) :: List.t()
  def zunion(keys, opts \\ []) do
    [
      "ZUNION",
      length(keys)
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc """
    Creates the zunionstore :eredis query list, based on the given arguments.
  """
  @spec zunionstore(String.t() | List.t() | Map.t(), List.t(), Keyword.t()) :: List.t()
  def zunionstore(key, keys, opts \\ []) do
    [
      "ZUNIONSTORE",
      if Keyword.get(opts, :jsonable, false) and
           Keyword.get(opts, :encode_key, false) do
        to_jstring(key, Keyword.get(opts, :json_opts, []))
      else
        key
      end,
      length(keys)
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(keys, Keyword.get(opts, :json_opts, []))
      else
        keys
      end
  end

  @doc """
    Creates the zscan :eredis query list, based on the given arguments.
  """
  @spec zscan(String.t() | Integer.t() | List.t() | Map.t(), List.t(), Keyword.t()) ::
          List.t()
  def zscan(key, values, opts \\ []) do
    [
      "ZSCAN",
      if is_integer(key) do
        key
      else
        if Keyword.get(opts, :jsonable, false) and
             Keyword.get(opts, :encode_key, false) do
          to_jstring(key, Keyword.get(opts, :json_opts, []))
        else
          key
        end
      end
    ] ++
      if Keyword.get(opts, :jsonable, false) do
        to_jstring(values, Keyword.get(opts, :json_opts, []))
      else
        values
      end
  end
end
