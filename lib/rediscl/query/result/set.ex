defmodule Rediscl.Query.Pipe.Result.Set do
  @moduledoc """
  	Result of set query
  """
  defstruct [:set]

  @type t :: %__MODULE__{
          set: String.t()
        }
end
