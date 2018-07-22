defmodule Rediscl.Query do
	@moduledoc """
    Minimal redis command
  """
	alias Rediscl.Work

  @doc """
    Run a command with key
  """
  def command(command, key), do: query(command, key)

	@doc """
    Run a command
  """
  def command(command), do: query(command)

  @doc """
    Get a key redis client
  """
  def get(key), do: query("GET", key)

  @doc """
    Multiple get a value with given keys redis client
  """
  def mget(keys) when is_list(keys), do: query("MGET", keys)

  @doc """
    Multiple get a value with given keys redis client when keys is nil
  """
  def mget(_), do: []

  @doc """ 
    Set a key, single value redis client
  """
  def set(key, value), do: query("SET", key, value)

  @doc """
    Multiple set a keys and values redis clients
  """
  def mset(key_and_values), do: query("MSET", key_and_values)

  def del(keys) when is_list(keys), do: query("DEL", keys)

  @doc """
    Del a key with given key name
  """
  def del(key), do: query("DEL", key)

  @doc """
    Left push for list with key and values when first param is key
  """
  def lpush(values, key) when is_list(values),
    do: query("LPUSH", key, values)

  @doc """
    Left push for list with key and values
  """
  def lpush(key, value),
    do: query("LPUSH", key, value)

  @doc """
    Right push for list with key and values when first param is key
  """
  def rpush(values, key) when is_list(values),
    do: query("RPUSH", key, values)

  @doc """
   Right push for list with key and values
  """
  def rpush(key, value),
    do: query("RPUSH", key, value)

  @doc """
    Get for list with given key and start indx and stop index
  """
  def lrange(key, start, stop),
    do: query("LRANGE", key, [start, stop])

  @doc """
    Set from list with given key and index and value
  """
  def lset(key, index, value),
    do: query("LSET", key, index, value)

  @doc """
    Remove from list element with given key and element count
  """
  def lrem(key, count, value),
    do: query("LREM", key, [count, value])

  @doc """
    Pipe queries  
  """
  def pipe(queries) when is_list(queries), 
    do: Work.query_pipe(queries) |> parse_response

  @doc false
  defp query(method, key, values) when is_list(values),
    do: Work.query([method, key] ++ values) |> parse_response

  @doc false
  defp query(method, key, value),
    do: Work.query([method, key, value]) |> parse_response

  @doc false
  defp query(method, key, index, value),
    do: Work.query([method, key, index, value]) |> parse_response

  @doc false
  defp query(method, key) when is_list(key),
    do: Work.query([method] ++ key) |> parse_response

  @doc false
  defp query(method, key),
    do: Work.query([method, key]) |> parse_response

  @doc false
  defp query(command),
    do: Work.query([command]) |> parse_response

  @doc false
  defp parse_response(response) do
    case response do
      "ERR " <> error ->
        {:error, error}
      response ->
        {:ok, response}
    end
  end
end