defmodule Rediscl.Query.Pipe do
	@moduledoc """
		Pipe query builder
	"""
	defstruct [:set, :get, :mset, :mget, :del, :lpush, :rpush, :lrange,
						:lrem, :lset]

	@pipes [:set, :get, :mset, :mget, :del, :lpush, :rpush, :lrange,
						:lrem, :lset]

	@type t :: %__MODULE__{
		set: String.t,
		get: String.t,
		mset: String.t,
		mget: List.t,
		del: String.t,
		lpush: String.t,
		rpush: String.t,
		lrange: String.t,
		lrem: String.t,
		lset: String.t
	}

	import Rediscl.Query.Api
	
	defmacro begin(pipes \\ []) when is_list(pipes) do
		build(pipes)
	end
	
	@doc false
	def build(pipes) when is_list(pipes) do
		Enum.into(pipes, %{})
		|> Enum.map(&(build(&1)))
	end

	@doc false
	def build({type, expr}) when type in @pipes do
		build(type, expr)
	end

	@doc false
	def build(type, expr) when type == :set do
		unless Enum.count(expr) == 2 and Enum.any?(expr, &typeof!(&1)),
			do: raise ArgumentError, "given parameters not valid"

		set(Enum.at(expr, 0), Enum.at(expr, 1))
	end

	@doc false
	def build(type, expr) when type == :get and is_binary(expr) do
		get(expr)
	end

	@doc false
	def build(type, expr) when type == :mset do
		unless Enum.count(expr) >= 2 and Enum.any?(expr, &typeof!(&1)),
			do: raise ArgumentError, "given parameters must be greater than 2 " <>
			 	"or given parameters not valid"
		
		mset(expr)
	end

	@doc false
	def build(type, expr) when type == :mget do
		unless Enum.count(expr) >= 2 and Enum.any?(expr, &typeof!(&1)),
			do: raise ArgumentError, "given parameters must be greater than or equal to 1" <>
			 	" or given parameters not valid"

		mget(expr)
	end

	@doc false
	def build(type, expr) when type == :del and is_list(expr) do
		unless Enum.any?(expr, &typeof!(&1)),
			do: raise ArgumentError, "given parameters not valid"

		del(expr)
	end

	@doc false
	def build(type, expr) when type == :lpush and is_list(expr) do
		unless Enum.count(expr) == 2 and typeof!(Enum.at(expr, 0)) and
			is_list(Enum.at(expr, 1)) and 
			Enum.any?(Enum.at(expr, 1), &typeof!(&1)),
			do: raise ArgumentError, "given parameters must be greater than 2 or " <>
				"values not list or values not valid type"

 		lpush(Enum.at(expr, 0), Enum.at(expr, 1))
	end

	@doc false
	def build(type, expr) when type == :rpush and is_list(expr) do
		unless Enum.count(expr) == 2 and typeof!(Enum.at(expr, 0)) and
			is_list(Enum.at(expr, 1)) and 
			Enum.any?(Enum.at(expr, 1), &typeof!(&1)),
			do: raise ArgumentError, "given parameters must be greater than 2 or " <>
				"values not list or values not valid type"

 		rpush(Enum.at(expr, 0), Enum.at(expr, 1))
	end

	@doc false
	def build(type, expr) when type == :lset do
		unless Enum.count(expr) === 3 and typeof!(Enum.at(expr, 0)) and
			is_integer(Enum.at(expr, 1)) and typeof!(Enum.at(expr, 2)),
			do: raise ArgumentError, "given parameters count equal to 3 or " <>
				"values not valid type"

 		lset(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
	end

	@doc false
	def build(type, expr) when type == :lrange do
		unless Enum.count(expr) == 3 and typeof!(Enum.at(expr, 0)) and
			is_integer(Enum.at(expr, 1)) and is_integer(String.to_integer(Enum.at(expr, 2))),
			do: raise ArgumentError, "given parameters count equal to 3 or " <>
				" values not valid type"

 		lrange(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
	end

	@doc false
	def build(type, expr) when type == :lrem do
		unless Enum.count(expr) == 3 and typeof!(Enum.at(expr, 0)) and
			is_integer(Enum.at(expr, 1)) and typeof!(Enum.at(expr, 2)),
			do: raise ArgumentError, "given parameters count equal to or " <>
				"values not valid type"

 		lrem(Enum.at(expr, 0), Enum.at(expr, 1), Enum.at(expr, 2))
	end

	@doc false
	def build(_, expr) when not is_binary(expr), 
		do: raise ArgumentError, "given parameter not valid"

	@doc false
	defp typeof!(v) do
		Rediscl.Typeable.typeof(v) == "string" 
	end
end