defmodule Rediscl.Query.ApiTest do
	use ExUnit.Case
	doctest Rediscl

	alias Rediscl.Query.Api

	test "command/2 keys is list" do
		assert ["EXPIRE", "key:1", 16_000] == Api.command("EXPIRE", ["key:1", 16_000])
	end

	test "command/2 keys is list with jsonable" do
		assert ["EXPIRE", Jason.encode!(%{
			key: 1
			}), 16_000] == Api.command("EXPIRE", [%{key: 1}, 16_000], 
			[{:jsonable, true}])
	end

	test "set/2" do
		assert ["SET", "key:1", "1"] == Api.set("key:1", "1")
	end

	test "set/2 with jsonable" do
		assert ["SET", Jason.encode!(%{
			key: 1
			}), "1"] == Api.set(%{key: 1}, "1", [{:jsonable, true}, {:encode_key, true}])
	end

	test "get/2" do
		assert ["GET", "key:1"] == Api.get("key:1")
	end

	test "get/2 with jsonable" do
		assert ["GET", Jason.encode!(%{
			key: 1
			})] == Api.get(%{key: 1}, [{:jsonable, true}])
	end

	test "mset/1" do
		assert ["MSET", "key:1", "value1", "key:2", "value2"] == 
			Api.mset(["key:1", "value1", "key:2", "value2"])
	end

	test "mset/1 with jsonable" do
		assert ["MSET", Jason.encode!(%{key: 1}), "value1", 
			Jason.encode!(%{key: 2}), Jason.encode!(%{value: 2})] == 
			Api.mset([%{key: 1}, "value1", %{key: 2}, %{value: 2}], [{:jsonable, true}])
	end

	test "mget/1" do
		assert ["MGET", "key:1", "key:2"] == Api.mget(["key:1", "key:2"])
	end

	test "mget/1 with jsonable" do
		assert ["MGET", Jason.encode!(%{key: 1}), "key:2"] == 
			Api.mget([%{key: 1}, "key:2"], [{:jsonable, true}])
	end

	test "del/1" do
		assert ["DEL", "key:1", "key:2"] == Api.del(["key:1", "key:2"])
	end

	test "del/1 with jsonable" do
		assert ["DEL", "key:1", Jason.encode!(%{key: 2})] == 
			Api.del(["key:1", %{key: 2}], [{:jsonable, true}])
	end

	test "lpush/2" do
		assert ["LPUSH", "key:1", "1", "2", "3"] == 
			Api.lpush("key:1", ["1", "2", "3"])
	end

	test "lpush/2 with jsonable" do
		assert ["LPUSH", Jason.encode!(%{key: 1}), "1", "2", "3"] == 
			Api.lpush(%{key: 1}, ["1", "2", "3"], 
				[{:jsonable, true}, {:encode_key, true}])
	end

	test "rpush/2" do
		assert ["RPUSH", "key:1", "1", "2", "3"] ==
			Api.rpush("key:1", ["1", "2", "3"])
	end

	test "rpush/2 with jsonable" do
		assert ["RPUSH", Jason.encode!(%{key: 1}), "1", "2", "3"] ==
			Api.rpush(%{key: 1}, ["1", "2", "3"], 
				[{:jsonable, true}, {:encode_key, true}])
	end

	test "lset/3" do
		assert ["LSET", "key:1", 0, "1"] == Api.lset("key:1", 0, "1") 
	end

	test "lset/3 with jsonable" do
		assert ["LSET", Jason.encode!(%{key: 1}), 0, Jason.encode!(%{value: 1})] == 
			Api.lset(%{key: 1}, 0, %{value: 1}, [{:jsonable, true}, {:encode_key, true}])
	end

	test "lrange/3" do
		assert ["LRANGE", "key:1", 0, "-1"] == Api.lrange("key:1", 0, "-1")
	end

	test "lrange/3 with jsonable" do
		assert ["LRANGE", Jason.encode!(%{key: 1}), 0, "-1"] == 
			Api.lrange(%{key: 1}, 0, "-1", [{:jsonable, true}, {:encode_key, true}])
	end

	test "lrem/3" do
		assert ["LREM", "key:1", 1, "1"] == Api.lrem("key:1", 1, "1")
	end

	test "sadd/2" do
		assert ["SADD", "key:1", "1", "2"] == Api.sadd("key:1", ["1", "2"])
	end

	test "scard/1" do
		assert ["SCARD", "key:1"] == Api.scard("key:1")
	end

	test "sdiff/1" do
		assert ["SDIFF", "key:1", "key:2"] == Api.sdiff(["key:1", "key:2"])
	end

	test "sdiffstore/2" do
		assert ["SDIFFSTORE", "key:3", "key:1", "key:2"] ==
			Api.sdiffstore("key:3", ["key:1", "key:2"])
	end

	test "sinter/1" do
		assert ["SINTER", "key:1", "key:2"] == Api.sinter(["key:1", "key:2"])
	end

	test "sinterstore/2" do
		assert ["SINTERSTORE", "key:3", "key:1", "key:2"] ==
			Api.sinterstore("key:3", ["key:1", "key:2"])
	end

	test "sismember/2" do
		assert ["SISMEMBER", "key:1", "value"] == Api.sismember("key:1", "value")
	end

	test "smembers/1" do
		assert ["SMEMBERS", "key:1"] == Api.smembers("key:1")
	end

	test "smove/3" do
		assert ["SMOVE", "key:1", "key:2", "value"] ==
			Api.smove("key:1", "key:2", "value")
	end

	test "spop/2" do
		assert ["SPOP", "key:1", -5] == Api.spop("key:1", -5)
	end

	test "spop/1" do
		assert ["SPOP", "key:1"] == Api.spop("key:1")
	end

	test "srandmember/2" do
		assert ["SRANDMEMBER", "key:1", 3] == Api.srandmember("key:1", 3)
	end

	test "srandmember/1" do
		assert ["SRANDMEMBER", "key:1"] == Api.srandmember("key:1")
	end

	test "srem/2" do
		assert ["SREM", "key:1", "value"] == Api.srem("key:1", ["value"])
	end

	test "srem/2 with key and values" do
		assert ["SREM", "key:1", "value", "value2"] == 
			Api.srem("key:1", ["value", "value2"])
	end

	test "sscan/2" do
		assert ["SSCAN", "key:1", 0, "match", "a*"] ==
			Api.sscan("key:1", [0, "match", "a*"])
	end

	test "sunion/1" do
		assert ["SUNION", "key:1", "key:3"] ==
			Api.sunion(["key:1", "key:3"])
	end

	test "sunionstore/2" do
		assert ["SUNIONSTORE", "key:4", "key:1", "key:3"] ==
			Api.sunionstore("key:4", ["key:1", "key:3"])
	end
end