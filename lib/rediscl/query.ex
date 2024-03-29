defmodule Rediscl.Query do
  @moduledoc """
    Minimal redis command
  """

  import Rediscl.Query.Util, only: [to_any: 2]

  alias Rediscl.Query.Api
  alias Rediscl.Work

  @doc """
    Run a command with key
  """
  def command(command, key, opts \\ []),
    do: query(Api.command(command, key, opts), opts)

  @doc """
    Run a command
  """
  def command(command), do: query(Api.command(command))

  @doc """
    Key is exists
  """
  def exists(key, opts \\ []), do: query(Api.exists(key, opts), opts)

  @doc ""
  def append(key, value, opts \\ []),
    do: query(Api.append(key, value, opts), opts)

  @doc """
    Get a key redis client
  """
  def get(key, opts \\ []), do: query(Api.get(key, opts), opts)

  @doc """
    Force et a key redis client
  """
  def get!(key, opts \\ []), do: query!(Api.get(key, opts), opts)

  @doc ""
  def get_range(key, start, stop, opts \\ []),
    do: query(Api.get_range(key, start, stop, opts), opts)

  @doc ""
  def get_set(key, value, opts \\ []),
    do: query(Api.get_set(key, value, opts), opts)

  @doc ""
  def strlen(key, opts \\ []), do: query(Api.strlen(key, opts), opts)

  @doc ""
  def incr(key, opts \\ []), do: query(Api.incr(key, opts), opts)

  @doc ""
  def incr_by_float(key, value, opts \\ []),
    do: query(Api.incr_by_float(key, value, opts), opts)

  @doc ""
  def incr_by(key, value, opts \\ []),
    do: query(Api.incr_by(key, value, opts), opts)

  @doc ""
  def decr(key, opts \\ []), do: query(Api.decr(key, opts), opts)

  @doc ""
  def decr_by(key, decrement, opts \\ []),
    do: query(Api.decr_by(key, decrement, opts), opts)

  @doc """
    Multiple get a value with given keys redis client
  """
  def mget(keys, opts \\ []) when is_list(keys),
    do: query(Api.mget(keys, opts), opts)

  @doc """
    Set a key, single value redis client
  """
  def set(key, value, opts \\ []), do: query(Api.set(key, value, opts), opts)

  @doc ""
  def set_ex(key, second, value, opts \\ []),
    do: query(Api.set_ex(key, second, value, opts), opts)

  @doc ""
  def set_nx(key, value, opts \\ []),
    do: query(Api.set_nx(key, value, opts), opts)

  @doc ""
  def set_range(key, offset, value, opts \\ []),
    do: query(Api.set_range(key, offset, value, opts), opts)

  @doc ""
  def pset_ex(key, milisecond, value, opts \\ []),
    do: query(Api.pset_ex(key, milisecond, value, opts), opts)

  @doc """
    Multiple set a keys and values redis clients
  """
  def mset(keys_and_values, opts \\ []) when is_list(keys_and_values),
    do: query(Api.mset(keys_and_values, opts), opts)

  @doc ""
  def mset_nx(keys_and_values, opts \\ []) when is_list(keys_and_values),
    do: query(Api.mset_nx(keys_and_values, opts), opts)

  @doc """
    Del a keys
  """
  def del(keys, opts \\ []), do: query(Api.del(keys, opts), opts)

  @doc """
    Left push for list with key and values
  """
  def lpush(key, value, opts \\ []),
    do: query(Api.lpush(key, List.flatten([value]), opts), opts)

  @doc """
   Right push for list with key and values
  """
  def rpush(key, value, opts \\ []),
    do: query(Api.rpush(key, List.flatten([value]), opts), opts)

  @doc """
    Get for list with given key and start indx and stop index
  """
  def lrange(key, start, stop, opts \\ []),
    do: query(Api.lrange(key, start, stop, opts), opts)

  @doc """
    Set from list with given key and index and value
  """
  def lset(key, index, value, opts \\ []),
    do: query(Api.lset(key, index, value, opts), opts)

  @doc """
    Remove from list element with given key and element count
  """
  def lrem(key, count, value, opts \\ []),
    do: query(Api.lrem(key, count, value, opts), opts)

  @doc ""
  def sadd(key, values, opts \\ []),
    do: query(Api.sadd(key, List.flatten([values]), opts), opts)

  @doc ""
  def scard(key, opts \\ []), do: query(Api.scard(key, opts), opts)

  @doc ""
  def sdiff(keys, opts \\ []), do: query(Api.sdiff(keys, opts), opts)

  @doc ""
  def sdiffstore(key, keys, opts \\ []),
    do: query(Api.sdiffstore(key, keys, opts), opts)

  @doc ""
  def sinter(keys, opts \\ []), do: query(Api.sinter(keys, opts), opts)

  @doc ""
  def sinterstore(key, keys, opts \\ []),
    do: query(Api.sinterstore(key, keys, opts), opts)

  @doc ""
  def sismember(key, value, opts \\ []),
    do: query(Api.sismember(key, value, opts), opts)

  @doc ""
  def smembers(key, opts \\ []), do: query(Api.smembers(key, opts), opts)

  @doc ""
  def smove(key_one, key_two, value, opts \\ []),
    do: query(Api.smove(key_one, key_two, value, opts), opts)

  @doc ""
  def spop(key, count \\ nil, opts \\ []),
    do: query(Api.spop(key, count, opts), opts)

  # @doc ""
  # def spop(key, opts \\ []), do: query(Api.spop(key, opts), opts)

  @doc ""
  def srandmember(key, count \\ nil, opts \\ []),
    do: query(Api.srandmember(key, count, opts), opts)

  # @doc ""
  # def srandmember(key, opts \\ []), do: query(Api.srandmember(key, opts), opts)

  @doc ""
  def srem(key, value_or_values, opts \\ []),
    do: query(Api.srem(key, List.flatten([value_or_values]), opts), opts)

  @doc ""
  def sscan(key, values, opts \\ []),
    do: query(Api.sscan(key, values, opts), opts)

  @doc ""
  def sunion(keys, opts \\ []), do: query(Api.sunion(keys, opts), opts)

  @doc ""
  def sunionstore(key, keys, opts \\ []),
    do: query(Api.sunionstore(key, keys, opts), opts)

  @doc """
  Adds one or more members to a sorted set, or updates its score, if it already exists.

  ## Examples
      iex> Rediscl.Query.zadd("key", 1, "value")
      {:ok, "1"}
  """
  def zadd(key, score, value, opts \\ []),
    do: query(Api.zadd(key, score, value, opts), opts)

  @doc """
  Gets the number of members in a sorted set.

  ## Examples
      iex> Rediscl.Query.zadd("key", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 1, "value2")
      {:ok, "1"}
      iex> Rediscl.Query.zcard("key")
      {:ok, "2"}
  """
  def zcard(key, opts \\ []),
    do: query(Api.zcard(key, opts), opts)

  @doc """
  Counts the members in a sorted set with scores within the given values.

  ## Examples
      iex> Rediscl.Query.zadd("key", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 1, "value2")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 2, "value3")
      {:ok, "1"}
      iex> Rediscl.Query.zcount("key", 1, 2)
      {:ok, "3"}
  """
  def zcount(key, min, max, opts \\ []),
    do: query(Api.zcount(key, min, max, opts), opts)

  @doc """
  Increments the score of a member in a sorted set.

  ## Examples
      iex> Rediscl.Query.zadd("key", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zincrby("key", 5, "value1")
      {:ok, "6"}
  """
  def zincrby(key, increment, value, opts \\ []),
    do: query(Api.zincrby(key, increment, value, opts), opts)

  @doc """
  Intersects multiple sorted sets and returns the resulting sorted set.

  ## Examples
      iex> Rediscl.Query.zadd("key1", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key2", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key2", 2, "value2")
      {:ok, "1"}
      iex> Rediscl.Query.zinter(["key1", "key2"])
      {:ok, ["value1"]}
  """
  def zinter(keys, opts \\ []),
    do: query(Api.zinter(keys, opts), opts)

  @doc """
  Intersects multiple sorted sets and stores the resulting sorted set in a new key.

  ## Examples
      iex> Rediscl.Query.zadd("key1", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key2", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key2", 2, "value2")
      {:ok, "1"}
      iex> Rediscl.Query.zinterstore("out", ["key1", "key2"])
      {:ok, "1"}
  """
  def zinterstore(key, keys, opts \\ []),
    do: query(Api.zinterstore(key, keys, opts), opts)

  @doc """
  Counts the number of members in a sorted set between a given lexicographical range.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zlexcount("key", "[b", "[c")
      {:ok, "2"}
  """
  def zlexcount(key, min, max, opts \\ []),
    do: query(Api.zlexcount(key, min, max, opts), opts)

  @doc """
  Returns a range of members in a sorted set, by index.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zrange("key", 0, -1)
      {:ok, ["a", "b", "c"]}
  """
  def zrange(key, min, max, opts \\ []),
    do: query(Api.zrange(key, min, max, opts), opts)

  @doc """
  Returns a range of members in a sorted set, by lexicographical range.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zrangebylex("key", "[a", "[c")
      {:ok, ["a", "b", "c"]}
  """
  def zrangebylex(key, min, max, opts \\ []),
    do: query(Api.zrangebylex(key, min, max, opts), opts)

  @doc """
  Returns a range of members in a sorted set, by score.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zrangebyscore("key", 0, 0)
      {:ok, ["a", "b", "c"]}
  """
  def zrangebyscore(key, min, max, opts \\ []),
    do: query(Api.zrangebyscore(key, min, max, opts), opts)

  @doc """
  Determines the index of a member in a sorted set.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zrank("key", "b")
      {:ok, "1"}
  """
  def zrank(key, value, opts \\ []),
    do: query(Api.zrank(key, value, opts), opts)

  @doc """
  Removes one or more members from a sorted set.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zrem("key", "a")
      {:ok, "1"}
  """
  def zrem(key, value, opts \\ []),
    do: query(Api.zrem(key, value, opts), opts)

  @doc """
  Removes all members in a sorted set between the given lexicographical range.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zremrangebylex("key", "[a", "[c")
      {:ok, "3"}
  """
  def zremrangebylex(key, min, max, opts \\ []),
    do: query(Api.zremrangebylex(key, min, max, opts), opts)

  @doc """
  Removes all members in a sorted set within the given indexes.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zremrangebyrank("key", 0, 2)
      {:ok, "3"}
  """
  def zremrangebyrank(key, min, max, opts \\ []),
    do: query(Api.zremrangebyrank(key, min, max, opts), opts)

  @doc """
  Removes all members in a sorted set within the given scores.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zremrangebyscore("key", 0, 0)
      {:ok, "3"}
  """
  def zremrangebyscore(key, min, max, opts \\ []),
    do: query(Api.zremrangebyscore(key, min, max, opts), opts)

  @doc """
  Returns a range of members in a sorted set, by index, with scores ordered from high to low.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zrevrange("key", 0, -1)
      {:ok, ["c", "b", "a"]}
  """
  def zrevrange(key, min, max, opts \\ []),
    do: query(Api.zrevrange(key, min, max, opts), opts)

  @doc """
  Returns a range of members in a sorted set, by lexicographical range, with lexicographical ranges ordered from high to low.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zrevrangebylex("key", "[c", "[a")
      {:ok, ["c", "b", "a"]}
  """
  def zrevrangebylex(key, max, min, opts \\ []),
    do: query(Api.zrevrangebylex(key, max, min, opts), opts)

  @doc """
  Returns a range of members in a sorted set, by score, with scores ordered from high to low.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zrevrangebyscore("key", 0, 0)
      {:ok, ["c", "b", "a"]}
  """
  def zrevrangebyscore(key, max, min, opts \\ []),
    do: query(Api.zrevrangebyscore(key, max, min, opts), opts)

  @doc """
  Determines the index of a member in a sorted set, with scores ordered from high to low.

  ## Examples
      iex> Rediscl.Query.zadd("key", 0, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "b")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 0, "c")
      {:ok, "1"}
      iex> Rediscl.Query.zrevrank("key", "a")
      {:ok, "2"}
  """
  def zrevrank(key, value, opts \\ []),
    do: query(Api.zrevrank(key, value, opts), opts)

  @doc """
  Gets the score associated with the given member in a sorted set.

  ## Examples
      iex> Rediscl.Query.zadd("key", 4, "a")
      {:ok, "1"}
      iex> Rediscl.Query.zscore("key", "a")
      {:ok, "4"}
  """
  def zscore(key, value, opts \\ []),
    do: query(Api.zscore(key, value, opts), opts)

  @doc """
  Adds multiple sorted sets and returns the resulting sorted set.

  ## Examples
      iex> Rediscl.Query.zadd("key1", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key2", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key2", 2, "value2")
      {:ok, "1"}
      iex> Rediscl.Query.zunion(["key1", "key2"])
      {:ok, ["value1", "value2"]}
  """
  def zunion(keys, opts \\ []),
    do: query(Api.zunion(keys, opts), opts)

  @doc """
  Adds multiple sorted sets and stores the resulting sorted set in a new key.

  ## Examples
      iex> Rediscl.Query.zadd("key1", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key2", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key2", 2, "value2")
      {:ok, "1"}
      iex> Rediscl.Query.zunionstore("out", ["key1", "key2"])
      {:ok, "2"}
  """
  def zunionstore(key, keys, opts \\ []),
    do: query(Api.zunionstore(key, keys, opts), opts)

  @doc """
  Incrementally iterates sorted sets elements and associated scores.

  ## Examples
      iex> Rediscl.Query.zadd("key", 1, "value1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 1, "value2")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 1, "oldvalue1")
      {:ok, "1"}
      iex> Rediscl.Query.zadd("key", 1, "anohter1")
      {:ok, "1"}
      iex> Rediscl.Query.zscan("key, "[0, "match", "anohter*"])
      {:ok, ["0", ["anohter1", "1"]]}
  """
  def zscan(key, values, opts \\ []),
    do: query(Api.zscan(key, values, opts), opts)

  @doc """
    Pipe queries
  """
  def pipe(queries) when is_list(queries),
    do: parse_response(Work.query_pipe(queries), :pipe)

  # @doc false
  # defp query(method, key, values) when is_list(values),
  #   do: Work.query([method, key] ++ values) |> parse_response

  # @doc false
  # defp query(method, key, value),
  #   do: Work.query([method, key, value]) |> parse_response

  # @doc false
  # defp query(method, key, index, value),
  #   do: Work.query([method, key, index, value]) |> parse_response

  # @doc false
  # defp query(method, key) when is_list(key),
  #   do: Work.query([method] ++ key) |> parse_response

  # @doc false
  # defp query(method, key),
  #   do: Work.query([method, key]) |> parse_response

  @doc false
  @spec query(List.t(), Keyword.t()) :: {:ok, any}
  defp query(command, opts \\ []) when is_list(command),
    do: parse_response(Work.query(command), opts)

  @doc false
  @spec query!(List.t(), Keyword.t()) :: {:ok, any}
  defp query!(command, opts \\ []) when is_list(command) do
    case parse_response(Work.query(command), opts) do
      {:ok, response} ->
        response

      {:error, error} ->
        raise Rediscl.Error.InvalidResponseError, %{status: :error, message: error}
    end
  end

  @doc false
  defp parse_response(response, :pipe) do
    {:ok, Enum.map(response, &elem(&1, 1))}
  end

  @doc false
  defp parse_response(response, opts) do
    case response do
      {:error, "ERR " <> error} ->
        {:error, error}

      {:error, "NOAUTH Authentication required."} ->
        {:error, :authentication_error}
        # {:error, error} ->
        {:error, :no_authentication_password}

      {:error, error} ->
        {:error, error}

      {:ok, :undefined} ->
        {:error, :undefined}

      {:ok, response} ->
        if Keyword.get(opts, :json_response, false) do
          {:ok, to_any(response, Keyword.get(opts, :json_response_opts, []))}
        else
          {:ok, response}
        end
    end
  end

  @doc ""
  @spec run_pipe(List.t()) :: {:ok, __MODULE__.Pipe.t()}
  def run_pipe(pipes) do
    __MODULE__.pipe(pipes)
  end
end
