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

  test "generate pipe query other commands" do
    query = begin set: ["key:10", "1"],
                  mset: ["key:11", "value2", "key:12", "value3"],
                  append: ["key:10", " 2"],
                  exists: "key:10",
                  setex: ["setex:1", 100, "value"],
                  setnx: ["key:14", "0"],
                  setrange: ["key:13", 10, "value"],
                  psetex: ["key:13", 1000, "-1"],
                  getrange: ["key:13", 0, 4],
                  getset: ["key:10", "10"],
                  strlen: "key:13",
                  incr: "key:10",
                  incrby: ["key:10", 4],
                  incrbyfloat: ["key:10", "1.1"],
                  decr: "key:10",
                  decrby: ["key:10", 9],
                  msetnx: ["key:21", "value", "key:22", "value"]

    assert query
  end

  test "generate pipe query with get methods" do
  	query = begin get: "key:1",
  								mget: ["key:2", "key:3"]

		assert Enum.at(query, 0) == ["GET", "key:1"]
		assert Enum.at(query, 1) == ["MGET", "key:2", "key:3"]
  end

  test "doesnt generate with invalid build append parameters" do
    assert_raise ArgumentError, fn -> 
      build :append, [1]
    end
  end

  test "doesnt generate with invalid build set parameters" do
  	assert_raise ArgumentError, fn -> 
  		build :set, ["key:16"]
  	end
  end

  test "doesnt genreate with invalid build setex parameters" do
    assert_raise ArgumentError, fn -> 
      build :setex, [1, "a1", false]
    end
  end

  test "doesnt genreate with invalid build setnx parameters" do
    assert_raise ArgumentError, fn -> 
      build :setnx, [1, false]
    end
  end

  test "doesnt genreate with invalid build setrange parameters" do
    assert_raise ArgumentError, fn -> 
      build :setrange, [1, "a1", false]
    end
  end

  test "doesnt genreate with invalid build psetex parameters" do
    assert_raise ArgumentError, fn -> 
      build :psetex, [1, false, false]
    end
  end

  test "doesnt generate with invalid build get parameteres" do
  	assert_raise FunctionClauseError, fn -> 
  		build :get, 1
  	end
  end

  test "doesnt genreate with invalid build getrange parameters" do
    assert_raise ArgumentError, fn -> 
      build :getrange, [false, "a1", "a2"]
    end
  end

  test "doesnt genreate with invalid build getset parameters" do
    assert_raise ArgumentError, fn -> 
      build :getset, [1, false]
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
  	assert_raise FunctionClauseError, fn -> 
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

  test "doesnt genreate with invalid build incrby parameters" do
    assert_raise ArgumentError, fn -> 
      build :incrby, [1, false]
    end
  end

  test "doesnt genreate with invalid build incrbyfloat parameters" do
    assert_raise ArgumentError, fn -> 
      build :incrbyfloat, [false, false]
    end
  end

  test "doesnt genreate with invalid build decrby parameters" do
    assert_raise ArgumentError, fn -> 
      build :decrby, [1, false]
    end
  end
end