defmodule Rediscl.Query.Pipe do
  @moduledoc """
  	Pipe query builder
  """
  defstruct [
    :set,
    :get,
    :mset,
    :mget,
    :del,
    :lpush,
    :rpush,
    :lrange,
    :lrem,
    :lset,
    :append,
    :exists,
    :setex,
    :setnx,
    :setrange,
    :psetex,
    :getrange,
    :getset,
    :strlen,
    :incr,
    :incrby,
    :incrbyfloat,
    :msetnx,
    :decr,
    :decrby,
    :sadd,
    :scard,
    :sdiff,
    :sdiffstore,
    :sinter,
    :sinterstore,
    :sismember,
    :smembers,
    :smove,
    :spop,
    :srandmember,
    :srem,
    :sscan,
    :sunion,
    :sunionstore,
    :zadd,
    :zcard,
    :zcount,
    :zincrby,
    :zinter,
    :zinterstore,
    :zlexcount,
    :zrange,
    :zrangebylex,
    :zrangebyscore,
    :zrank,
    :zrem,
    :zremrangebylex,
    :zremrangebyrank,
    :zremrangebyscore,
    :zrevrange,
    :zrevrangebylex,
    :zrevrangebyscore,
    :zrevrank,
    :zscore,
    :zunion,
    :zunionstore,
    :zscan
  ]

  @pipes [
    :set,
    :get,
    :mset,
    :mget,
    :del,
    :lpush,
    :rpush,
    :lrange,
    :lrem,
    :lset,
    :append,
    :exists,
    :setex,
    :setnx,
    :setrange,
    :psetex,
    :getrange,
    :getset,
    :strlen,
    :incr,
    :incrby,
    :incrbyfloat,
    :msetnx,
    :decr,
    :decrby,
    :sadd,
    :scard,
    :sdiff,
    :sdiffstore,
    :sinter,
    :sinterstore,
    :sismember,
    :smembers,
    :smove,
    :spop,
    :srandmember,
    :srem,
    :sscan,
    :sunion,
    :sunionstore,
    :zadd,
    :zcard,
    :zcount,
    :zincrby,
    :zinter,
    :zinterstore,
    :zlexcount,
    :zrange,
    :zrangebylex,
    :zrangebyscore,
    :zrank,
    :zrem,
    :zremrangebylex,
    :zremrangebyrank,
    :zremrangebyscore,
    :zrevrange,
    :zrevrangebylex,
    :zrevrangebyscore,
    :zrevrank,
    :zscore,
    :zunion,
    :zunionstore,
    :zscan
  ]

  import Rediscl.Query.Api

  defmacro begin(pipes \\ []) when is_list(pipes) do
    build(pipes)
  end

  @doc ""
  def build(pipes) when is_list(pipes) do
    Enum.into(pipes, %{})
    |> Enum.map(&build(&1))
  end

  @doc ""
  def build({type, expr}) when type in @pipes do
    build(type, expr)
  end

  @doc ""
  def build(type, expr) when type == :exists and is_binary(expr) do
    exists(expr)
  end

  @doc ""
  def build(type, expr) when type == :append and is_list(expr) do
    unless Enum.count(expr) == 2 and Enum.any?(expr, &typeof!(&1)),
      do: raise(ArgumentError, "append given parameters not valid")

    append(Enum.at(expr, 0), Enum.at(expr, 0))
  end

  @doc ""
  def build(type, expr) when type == :set and is_list(expr) do
    unless Enum.count(expr) == 2 and Enum.any?(expr, &typeof!(&1)),
      do: raise(ArgumentError, "set given parameters not valid")

    set(Enum.at(expr, 0), Enum.at(expr, 1))
  end

  @doc ""
  def build(type, expr) when type == :setex and is_list(expr) do
    unless Enum.count(expr) == 3 and typeof!(Enum.at(expr, 0)) and
             is_integer(Enum.at(expr, 1)) and
             (typeof!(Enum.at(expr, 2)) or is_integer(Enum.at(expr, 2))),
           do: raise(ArgumentError, "setex given parameters not valid")

    set_ex(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
  end

  @doc ""
  def build(type, expr) when type == :setnx and is_list(expr) do
    unless Enum.count(expr) == 2 and typeof!(Enum.at(expr, 0)) and
             (is_integer(Enum.at(expr, 1)) or typeof!(Enum.at(expr, 1))),
           do: raise(ArgumentError, "setnx given parameters not valid")

    set_nx(Enum.at(expr, 0), Enum.at(expr, 1))
  end

  @doc ""
  def build(type, expr) when type == :setrange and is_list(expr) do
    unless Enum.count(expr) == 3 and typeof!(Enum.at(expr, 0)) and
             is_integer(Enum.at(expr, 1)) and typeof!(Enum.at(expr, 2)),
           do: raise(ArgumentError, "setrange given parameters not valid")

    set_range(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
  end

  @doc ""
  def build(type, expr) when type == :psetex and is_list(expr) do
    unless Enum.count(expr) == 3 and typeof!(Enum.at(expr, 0)) and
             is_integer(Enum.at(expr, 1)) and
             (typeof!(Enum.at(expr, 2)) or is_integer(Enum.at(expr, 2))),
           do: raise(ArgumentError, "psetex given parameters not valid")

    pset_ex(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
  end

  @doc ""
  def build(type, expr) when type == :get and is_binary(expr) do
    get(expr)
  end

  @doc ""
  def build(type, expr) when type == :getrange and is_list(expr) do
    unless Enum.count(expr) == 3 and typeof!(Enum.at(expr, 0)) and
             Enum.any?(expr, &is_integer/1),
           do: raise(ArgumentError, "getrange given parameters not valid")

    get_range(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
  end

  @doc ""
  def build(type, expr) when type == :getset and is_list(expr) do
    unless Enum.count(expr) == 2 and Enum.any?(expr, &typeof!/1),
      do: raise(ArgumentError, "getset given parameters not valid")

    get_set(Enum.at(expr, 0), Enum.at(expr, 1))
  end

  @doc ""
  def build(type, expr) when type == :strlen and is_binary(expr) do
    strlen(expr)
  end

  @doc ""
  def build(type, expr) when type == :incr and is_binary(expr) do
    incr(expr)
  end

  @doc ""
  def build(type, expr) when type == :incrby and is_list(expr) do
    unless Enum.count(expr) == 2 and typeof!(Enum.at(expr, 0)) and
             is_integer(Enum.at(expr, 1)),
           do: raise(ArgumentError, "incrby given parameters not valid")

    incr_by(Enum.at(expr, 0), Enum.at(expr, 1))
  end

  @doc ""
  def build(type, expr) when type == :incrbyfloat and is_list(expr) do
    unless Enum.count(expr) == 2 and Enum.any?(expr, &typeof!/1),
      do: raise(ArgumentError, "incrbyfloat given parameters not valid")

    incr_by_float(Enum.at(expr, 0), Enum.at(expr, 1))
  end

  @doc ""
  def build(type, expr) when type == :decr and is_binary(expr) do
    decr(expr)
  end

  @doc ""
  def build(type, expr) when type == :decrby and is_list(expr) do
    unless Enum.count(expr) == 2 and typeof!(Enum.at(expr, 0)) and
             is_integer(Enum.at(expr, 1)),
           do: raise(ArgumentError, "decrby given parameters not valid")

    decr_by(Enum.at(expr, 0), Enum.at(expr, 1))
  end

  @doc ""
  def build(type, expr) when type == :mset and is_list(expr) do
    unless Enum.count(expr) >= 2 and Enum.any?(expr, &typeof!(&1)),
      do:
        raise(
          ArgumentError,
          "mset given parameters must be greater than 2 " <>
            "or given parameters not valid"
        )

    mset(expr)
  end

  @doc ""
  def build(type, expr) when type == :msetnx and is_list(expr) do
    mset_nx(expr)
  end

  @doc ""
  def build(type, expr) when type == :mget do
    unless Enum.count(expr) >= 2 and Enum.any?(expr, &typeof!(&1)),
      do:
        raise(
          ArgumentError,
          "mget given parameters must be greater than or equal to 1" <>
            " or given parameters not valid"
        )

    mget(expr)
  end

  @doc ""
  def build(type, expr)
      when (type == :del and
              is_list(expr)) or is_binary(expr) do
    unless Enum.any?(expr, &typeof!(&1)),
      do: raise(ArgumentError, "del given parameters not valid")

    del(expr)
  end

  @doc ""
  def build(type, expr) when type == :lpush and is_list(expr) do
    unless Enum.count(expr) == 2 and typeof!(Enum.at(expr, 0)) and
             is_list(Enum.at(expr, 1)) and
             Enum.any?(Enum.at(expr, 1), &typeof!(&1)),
           do:
             raise(
               ArgumentError,
               "lpush given parameters must be greater than 2 or " <>
                 "values not list or values not valid type"
             )

    lpush(Enum.at(expr, 0), Enum.at(expr, 1))
  end

  @doc ""
  def build(type, expr) when type == :rpush and is_list(expr) do
    unless Enum.count(expr) == 2 and typeof!(Enum.at(expr, 0)) and
             is_list(Enum.at(expr, 1)) and
             Enum.any?(Enum.at(expr, 1), &typeof!(&1)),
           do:
             raise(
               ArgumentError,
               "rpush given parameters must be greater than 2 or " <>
                 "values not list or values not valid type"
             )

    rpush(Enum.at(expr, 0), Enum.at(expr, 1))
  end

  @doc ""
  def build(type, expr) when type == :lset do
    unless Enum.count(expr) === 3 and typeof!(Enum.at(expr, 0)) and
             is_integer(Enum.at(expr, 1)) and typeof!(Enum.at(expr, 2)),
           do:
             raise(
               ArgumentError,
               "lset given parameters count equal to 3 or " <>
                 "values not valid type"
             )

    lset(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
  end

  @doc ""
  def build(type, expr) when type == :lrange do
    unless Enum.count(expr) == 3 and typeof!(Enum.at(expr, 0)) and
             is_integer(Enum.at(expr, 1)) and is_integer(String.to_integer(Enum.at(expr, 2))),
           do:
             raise(
               ArgumentError,
               "lrange given parameters count equal to 3 or " <>
                 " values not valid type"
             )

    lrange(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
  end

  @doc ""
  def build(type, expr) when type == :lrem do
    unless Enum.count(expr) == 3 and typeof!(Enum.at(expr, 0)) and
             is_integer(Enum.at(expr, 1)) and typeof!(Enum.at(expr, 2)),
           do:
             raise(
               ArgumentError,
               "lrem given parameters count equal to or " <>
                 "values not valid type"
             )

    lrem(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
  end

  @doc false
  defp typeof!(v) do
    Rediscl.Typeable.typeof(v) == "string"
  end
end
