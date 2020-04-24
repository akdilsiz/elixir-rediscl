defmodule Rediscl.Query.UtilTest do
  use ExUnit.Case
  doctest Rediscl

  Application.put_env(:rediscl, :json_library, Jason)

  alias Rediscl.Query.Util

  test "to_jstring/1 with binary params" do
    assert "binary" == Util.to_jstring("binary")
  end

  test "to_jstring/1 with map params" do
    assert Jason.encode!(%{
             map: true
           }) ==
             Util.to_jstring(%{
               map: true
             })
  end

  test "to_jstring/1 with list params" do
    assert [
             Jason.encode!(%{
               map: true
             }),
             Jason.encode!(%{
               map: false
             })
           ] ==
             Util.to_jstring([
               %{
                 map: true
               },
               %{
                 map: false
               }
             ])
  end
end
