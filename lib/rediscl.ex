defmodule Rediscl do
  @moduledoc false
  use Application
  alias Rediscl.Superv

  @pool_size Application.get_env(:rediscl, :pool, 15)
  @pool_max_overflow Application.get_env(:rediscl, :pool_max_overflow, 2)

  def start(_type, _args) do
    Superv.start_link([name: {:local, Rediscl},
                      worker_module: __MODULE__.Work,
                      size: @pool_size,
                      max_overflow: @pool_max_overflow])
  end
end
