defmodule Rediscl.Superv do
  @moduledoc false
  @doc false
  use Supervisor

  def start_link(conf) do
    Supervisor.start_link(__MODULE__, conf, name: __MODULE__)
  end

  def init(conf) do
    children = [
      :poolboy.child_spec(Rediscl, conf, [])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def stop(pid, timeout \\ 5000) do
    Supervisor.stop(pid, :normal, timeout)

    :ok
  end
end
