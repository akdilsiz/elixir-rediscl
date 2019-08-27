defmodule Rediscl.QueryTestStruct do
	@moduledoc """
		Test Struct	
	"""
  @derive {Jason.Encoder, only: [:key, :value]}
  defstruct [
    :key,
    :value
  ]
end