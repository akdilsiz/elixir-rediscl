defmodule Rediscl.Error.InvalidResponseError do
  defexception [:status, :message]

  @impl true
  def exception(%{status: status, message: message}) do
    %Rediscl.Error.InvalidResponseError{status: status, message: message}
  end
end
