defmodule Rediscl.Query.ApiTest do
	use ExUnit.Case
	doctest Rediscl

	alias Rediscl.Query.Api

	test "set/2" do
		assert ["SET", "key:1", "1"] == Api.set("key:1", "1")
	end

	test "get/2" do
		assert ["GET", "key:1"] == Api.get("key:1")
	end

	test "mset/1" do
		assert ["MSET", "key:1", "value1", "key:2", "value2"] == 
			Api.mset(["key:1", "value1", "key:2", "value2"])
	end

	test "mget/1" do
		assert ["MGET", "key:1", "key:2"] == Api.mget(["key:1", "key:2"])
	end

	test "del/1" do
		assert ["DEL", "key:1", "key:2"] == Api.del(["key:1", "key:2"])
	end

	test "lpush/2" do
		assert ["LPUSH", "key:1", "1", "2", "3"] == 
			Api.lpush("key:1", ["1", "2", "3"])
	end

	test "rpush/2" do
		assert ["RPUSH", "key:1", "1", "2", "3"] ==
			Api.rpush("key:1", ["1", "2", "3"])
	end

	test "lset/3" do
		assert ["LSET", "key:1", 0, "1"] == Api.lset("key:1", 0, "1") 
	end

	test "lrange/3" do
		assert ["LRANGE", "key:1", 0, "-1"] == Api.lrange("key:1", 0, "-1")
	end

	test "lrem/3" do
		assert ["LREM", "key:1", 1, "1"] == Api.lrem("key:1", 1, "1")
	end
end