defmodule Rediscl.Work do
	@moduledoc false
	use GenServer

	@host Application.get_env(:rediscl, :host, "127.0.0.1")
	@port Application.get_env(:rediscl, :port, 6379)
	@database Application.get_env(:rediscl, :database, 0)
	@password Application.get_env(:rediscl, :password, "")
	@reconnnect Application.get_env(:rediscl, :reconnnect, :no_reconnect)
	@timeout Application.get_env(:rediscl, :timeout, 15_000)

	def start_link(_args) do
		GenServer.start_link(__MODULE__, [], [])
	end

	def init(_) do
		case build_conn() do
			{:ok, conn} ->
				{:ok, %{conn: conn}}
			{:error, error} ->
				{:error, error}
		end
	end

	@doc false
  def handle_call(%{command: command, params: params}, _from, %{conn: conn}) do
    conn = __MODULE__.ensure(conn)
    case command do
      :query ->
        {:reply, :eredis.q(conn, params), %{conn: conn}}
      :query_pipe ->
      	{:reply, :eredis.qp(conn, params), %{conn: conn}}
    end
	end

	@doc false
  def ensure(conn) do
    if Process.alive?(conn), do: conn, else: elem(build_conn(), 1)
  end

  @doc false
  def perform(call) do
    :poolboy.transaction(Rediscl, fn(worker) ->
      GenServer.call(worker, call)
    end, @timeout)
	end

  @doc false
  def query(args) do
   	__MODULE__.perform(%{command: :query, params: args})
	end

  @doc false
  def query_pipe(args) do
    __MODULE__.perform(%{command: :query_pipe, params: args})
	end

	defp build_conn() do
		:eredis.start_link(to_charlist(@host), @port, @database, to_charlist(@password), @reconnnect)
	end
end