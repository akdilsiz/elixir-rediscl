defmodule Rediscl.Work do
  @moduledoc false
  @doc false
  use GenServer

  @host Application.compile_env(:rediscl, :host, "127.0.0.1")
  @port Application.compile_env(:rediscl, :port, 6379)
  @database Application.compile_env(:rediscl, :database, 0)
  @password Application.compile_env(:rediscl, :password, "")
  @timeout Application.compile_env(:rediscl, :timeout, 15_000)

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

  def handle_call(%{command: command, params: params}, _from, %{conn: conn}) do
    conn = __MODULE__.ensure(conn)

    case command do
      :query ->
        {:reply, :eredis.q(conn, params), %{conn: conn}}

      :query_pipe ->
        {:reply, :eredis.qp(conn, params), %{conn: conn}}
    end
  end

  def ensure(conn) do
    if Process.alive?(conn), do: conn, else: elem(build_conn(), 1)
  end

  def perform(call) do
    :poolboy.transaction(
      Rediscl,
      fn worker ->
        GenServer.call(worker, call)
      end,
      @timeout
    )
  end

  def query(args) do
    __MODULE__.perform(%{command: :query, params: args})
  end

  def query_pipe(args) do
    __MODULE__.perform(%{command: :query_pipe, params: args})
  end

  defp build_conn do
    :eredis.start_link([host: @host,
      port: @port,
      database: @database,
      password: to_charlist(@password),
      timeout: @timeout,
      socket_options: [{:keepalive, true}]])
  end
end
