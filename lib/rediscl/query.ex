defmodule Rediscl.Query do
	@moduledoc """
    Minimal redis command
  """
	alias Rediscl.Work
  alias Rediscl.Query.Api

  @doc """
    Run a command with key
  """
  def command(command, key), do: query(Api.command(command, key))

	@doc """
    Run a command
  """
  def command(command), do: query(Api.command(command))

  @doc """
    Key is exists
  """
  def exists(key), do: query(Api.exists(key))

  @doc ""
  def append(key, value), do: query(Api.append(key, value))

  @doc """
    Get a key redis client
  """
  def get(key), do: query(Api.get(key))

  @doc ""
  def get_range(key, start, stop),
    do: query(Api.get_range(key, start, stop))

  @doc ""
  def get_set(key, value), do: query(Api.get_set(key, value))

  @doc ""
  def strlen(key), do: query(Api.strlen(key))

  @doc ""
  def incr(key), do: query(Api.incr(key))

  @doc ""
  def incr_by_float(key, value), do: query(Api.incr_by_float(key, value))

  @doc ""
  def incr_by(key, value), do: query(Api.incr_by(key, value))

  @doc ""
  def decr(key), do: query(Api.decr(key))

  @doc ""
  def decr_by(key, decrement), do: query(Api.decr_by(key, decrement))

  @doc """
    Multiple get a value with given keys redis client
  """
  def mget(keys) when is_list(keys), do: query(Api.mget(keys))

  @doc """ 
    Set a key, single value redis client
  """
  def set(key, value), do: query(Api.set(key, value))

  @doc ""
  def set_ex(key, second, value), 
    do: query(Api.set_ex(key, second, value))

  @doc ""
  def set_nx(key, value), do: query(Api.set_nx(key, value))

  @doc ""
  def set_range(key, offset, value), 
    do: query(Api.set_range(key, offset, value))

  @doc ""
  def pset_ex(key, milisecond, value),
    do: query(Api.pset_ex(key, milisecond, value))

  @doc """
    Multiple set a keys and values redis clients
  """
  def mset(keys_and_values) when is_list(keys_and_values), 
    do: query(Api.mset(keys_and_values))

  @doc ""
  def mset_nx(keys_and_values) when is_list(keys_and_values),
    do: query(Api.mset_nx(keys_and_values))

  def del(keys) when is_list(keys), do: query(Api.del(keys))

  @doc """
    Del a key with given key name
  """
  def del(key), do: query(Api.del([key]))

  @doc """
    Left push for list with key and values when first param is key
  """
  def lpush(values, key) when is_list(values),
    do: query(Api.lpush(key, values))

  @doc """
    Left push for list with key and values
  """
  def lpush(key, value),
    do: query(Api.lpush(key, List.flatten([value])))

  @doc """
    Right push for list with key and values when first param is key
  """
  def rpush(values, key) when is_list(values),
    do: query(Api.rpush(key, values))

  @doc """
   Right push for list with key and values
  """
  def rpush(key, value),
    do: query(Api.rpush(key, List.flatten([value])))

  @doc """
    Get for list with given key and start indx and stop index
  """
  def lrange(key, start, stop),
    do: query(Api.lrange(key, start, stop))

  @doc """
    Set from list with given key and index and value
  """
  def lset(key, index, value),
    do: query(Api.lset(key, index, value))

  @doc """
    Remove from list element with given key and element count
  """
  def lrem(key, count, value),
    do: query(Api.lrem(key, count, value))

  @doc ""
  def sadd(key, values),
    do: query(Api.sadd(key, values))

  @doc ""
  def scard(key), do: query(Api.scard(key))

  @doc ""
  def sdiff(keys), do: query(Api.sdiff(keys))

  @doc ""
  def sdiffstore(key, keys), do: query(Api.sdiffstore(key, keys))

  @doc ""
  def sinter(keys), do: query(Api.sinter(keys))

  @doc ""
  def sinterstore(key, keys), do: query(Api.sinterstore(key, keys))

  @doc ""
  def sismember(key, value), do: query(Api.sismember(key, value)) 

  @doc ""
  def smembers(key), do: query(Api.smembers(key))

  @doc ""
  def smove(key_one, key_two, value), 
    do: query(Api.smove(key_one, key_two, value))

  @doc ""
  def spop(key, count), do: query(Api.spop(key, count))

  @doc ""
  def spop(key), do: query(Api.spop(key))

  @doc ""
  def srandmember(key, count), do: query(Api.srandmember(key, count))

  @doc ""
  def srandmember(key), do: query(Api.srandmember(key))

  @doc ""
  def srem(key, value_or_values), do: query(Api.srem(key, value_or_values))

  @doc ""
  def sscan(key, values), do: query(Api.sscan(key, values))

  @doc ""
  def sunion(keys), do: query(Api.sunion(keys))

  @doc ""
  def sunionstore(key, keys), do: query(Api.sunionstore(key, keys))

  @doc """
    Pipe queries  
  """
  def pipe(queries) when is_list(queries), 
    do: Work.query_pipe(queries) |> parse_response(:pipe)

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
  @spec query(List.t) :: {:ok, any}
  defp query(command) when is_list(command),
    do: Work.query(command) |> parse_response

  @doc false
  defp parse_response(response, :pipe) do
    {:ok, Enum.map(response, &(elem(&1, 1)))}
  end

  @doc false
  defp parse_response(response) do
    case response do
      {:error, "ERR " <> error} ->
        {:error, error}
      {:error, "NOAUTH Authentication required."} ->
        {:error, :authentication_error}
      # {:error, error} ->
        {:error, :no_authentication_password}
      {:ok, response} ->
        {:ok, response}
    end
  end

  @doc ""
  @spec run_pipe(List.t) :: {:ok, __MODULE__.Pipe.t}
  def run_pipe(pipes) do
    {:ok, results} = __MODULE__.pipe(pipes)
    # {results, _} =
    #   Enum.map_reduce(results, 0, fn (x, acc) -> 
    #     pipe = Enum.at(pipes, acc)

    #     {{String.to_atom(String.downcase(List.first(pipe))), x}, 
    #       acc + 1}
    #   end)
    
    # results = struct(__MODULE__.Pipe.Result, results)

    {:ok, results}
  end
end