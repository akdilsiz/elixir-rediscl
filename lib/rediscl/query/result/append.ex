defmodule Rediscl.Query.Pipe.Result.Append do
	@moduledoc """
		Result of append query
	"""
	defstruct [:append]

	@type t :: %__MODULE__{
		append: Integer.t
	}
end