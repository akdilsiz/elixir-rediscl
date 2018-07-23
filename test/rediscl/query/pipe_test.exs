defmodule Rediscl.Query.PipeTest do
  use ExUnit.Case
  doctest Rediscl

  import Rediscl.Query.Pipe

  test "generate pipe query" do
		query = begin set: ["key:10", "1"],
									mset: ["key:11", "value2", "key:12", "value3"],
									del: ["key:10", "key:11"],
									lpush: ["key:13", ["-1", "-2", "-3"]],
									rpush: ["key:14", ["1", "2", "3"]],
									lset: ["key:14", 0, "0"],
									lrange: ["key:13", 0, "-1"],
									lrem: ["key:13", 1, "-1"]

		assert Enum.at(query, 0) == ["DEL", "key:10", "key:11"]
		assert Enum.at(query, 1) == ["LPUSH", "key:13", "-1", "-2", "-3"]
		assert Enum.at(query, 2) == ["LRANGE", "key:13", 0, "-1"]
		assert Enum.at(query, 3) == ["LREM", "key:13", 1, "-1"]
		assert Enum.at(query, 4) == ["LSET", "key:14", 0, "0"]
		assert Enum.at(query, 5) == ["MSET", "key:11", "value2", "key:12", "value3"]
		assert Enum.at(query, 6) == ["RPUSH", "key:14", "1", "2", "3"]
		assert Enum.at(query, 7) == ["SET", "key:10", "1"]
  end

  test "generate pipe query with get methods" do
  	query = begin get: "key:1",
  								mget: ["key:2", "key:3"]

		assert Enum.at(query, 0) == ["GET", "key:1"]
		assert Enum.at(query, 1) == ["MGET", "key:2", "key:3"]
  end

  test "doesnt generate with invalid build set parameters" do
  	assert_raise ArgumentError, fn -> 
  		build :set, ["key:16"]
  	end
  end

  test "doesnt generate with invalid build get parameteres" do
  	assert_raise ArgumentError, fn -> 
  		build :get, 1
  	end
  end

  test "doesnt generate with invalid build mset parameteres" do
  	assert_raise ArgumentError, fn -> 
  		build :mset, ["key:123"]
  	end
  end

  test "doesnt generate with invalid build mget parameters" do
  	assert_raise ArgumentError, fn -> 
  		build :mget, ["key:123"]
  	end
  end

  test "doesnt generate with invalid build del parametets" do
  	assert_raise ArgumentError, fn -> 
  		build :del, 1
  	end
  end

  test "doesnt generate with is list build del if not valid types" do
  	assert_raise ArgumentError, fn -> 
  		build :del, [1, 3]
  	end
  end

  test "doesnt generate with invalid build lpush parameters" do
  	assert_raise ArgumentError, fn -> 
  		build :lpush, [1, 2]
  	end
  end

  test "doesnt generate with invalid build rpush parameters" do
  	assert_raise ArgumentError, fn -> 
  		build :rpush, [1, 2]
  	end
  end

  test "doesnt generate with invalid build lset parameters" do
  	assert_raise ArgumentError, fn -> 
  		build :lset, [1, 2]
  	end
  end

  test "doesnt generate with invalid build lrem parameters" do
  	assert_raise ArgumentError, fn -> 
  		build :lrem, [1, 2]
  	end
  end

  test "doesnt generate with invalid build lrange parameters" do
  	assert_raise ArgumentError, fn -> 
  		build :lrange, ["key:1", 0]
  	end
  end
end