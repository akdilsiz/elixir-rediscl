defmodule Rediscl.Query.Pipe.Result do
	@moduledoc """
		Result of pipe query
	"""
	defstruct [:set, :get, :mset, :mget, :del, :lpush, :rpush, :lrange,
						:lrem, :lset, :append, :exists, :setex, :setnx, :setrange, :psetex,
						:getrange, :getset, :strlen, :incr, :incrby, :incrbyfloat,
						:msetnx, :decr, :decrby]

	@type t :: %__MODULE__{
		append: Integer.t, 
		set: String.t,
		setex: String.t,
		setnx: String.t,
		setrange: Integer.t,
		psetex: String.t,
		get: String.t,
		getrange: String.t,
		getset: String.t,
		strlen: Integer.t,
		incr: Integer.t,
		incrby: Integer.t,
		incrbyfloat: String.t,
		decr: Integer.t,
		decrby: Integer.t,
		mset: String.t,
		msetnx: Integer.t,
		mget: List.t,
		del: String.t,
		lpush: String.t,
		rpush: String.t,
		lrange: String.t,
		lrem: String.t,
		lset: String.t
	}
end