defmodule Rediscl.QueryTest do
	use ExUnit.Case
  doctest Rediscl

  alias Rediscl.Query
  import Rediscl.Query.Pipe

  setup do
  	{:ok, keys} = Query.command("KEYS", "*")
  	
  	Query.del(keys)

  	:ok
  end

  test "run_pipe/1" do
    query = begin set: ["key:10", "1"],
                  set: ["key:1234", "1234"],
                  mset: ["key:11", "value2", "key:12", "value3"],
                  lpush: ["key:13", ["-1", "-2", "-3"]],
                  rpush: ["key:14", ["1", "2", "3"]],
                  lrange: ["key:13", 0, "-1"],
                  lrem: ["key:13", 1, "-1"]

    assert {:ok, _results} = Query.run_pipe(query)
  end

  test "run_pipe/1 other commands" do
    query = begin set: ["key:10", 10],
                  mset: ["key:11", "value2", "key:12", "value3"],
                  append: ["key:11", "value2"],
                  exists: "key:10",
                  setex: ["setex:1", 100, "value"],
                  setnx: ["key:14", "0"],
                  setrange: ["key:13", 10, "value"],
                  psetex: ["key:13", 1000, "-1"],
                  getrange: ["key:13", 0, 4],
                  get: "key:10",
                  getset: ["key:10", 11],
                  strlen: "key:13",
                  incr: "key:10",
                  incrby: ["key:10", 4],
                  incrbyfloat: ["key:10", "1.1"],
                  decr: "key:10",
                  decrby: ["key:10", 1],
                  msetnx: ["key:21", "value", "key:22", "value"]

    assert {:ok, _results} = Query.run_pipe(query)
  end

  test "command/1 test" do
  	command = Query.command("INFO")
		
		assert {:ok, _response} = command
  end

  test "command/2 test" do
  	command = Query.command("KEYS", "*")

  	{:ok, _keys} = command
  end

  test "command/1 unknown commant test" do
  	command = Query.command("UNKNOWN")

  	assert {:error, "unknown command 'UNKNOWN'"} = command
  end

  test "exists/1" do
    {:ok, "OK"} = Query.set("exists", "1")

    exists = Query.exists("exists")

    assert {:ok, "1"} == exists
  end

  test "append/2 with given key and value" do
    {:ok, "OK"} = Query.set("append", "Hello")
    
    {:ok, "11"} = Query.append("append", " World")
  end

  test "set/2 query with given key and value" do
  	set = Query.set("test:1", 1)

  	assert {:ok, "OK"} = set
  end

  test "set_ex/3 with given key, seconds and value" do
    {:ok, "OK"} = Query.set_ex("setex", 10, "value")
  end

  test "set_nx/2 with given key and value" do
    {:ok, "1"} = Query.set_nx("setnx", "value")
  end

  test "set_range/3 with given key, offset and value" do
    {:ok, "15"} = Query.set_range("setrange", 10, "value")
  end

  test "pset_ex/3 with given key, miliseconds and value" do
    {:ok, "OK"} = Query.pset_ex("psetex", 1000, "value")
  end

  test "get query with given key" do
  	set = Query.set("test:2", 2)

  	assert {:ok, "OK"} = set

  	get = Query.get("test:2")

  	assert {:ok, "2"} = get
  end

  test "get_range/3 with given key, start and stop " do
    {:ok, "OK"} = Query.set("get_range", "Hello World")

    {:ok, "Hello"} = Query.get_range("get_range", 0, 4)
  end

  test "get_set/2 with given key and value" do
    {:ok, "OK"} = Query.set("get_set", 1)

    {:ok, "1"} = Query.get("get_set")

    {:ok, "1"} = Query.get_set("get_set", 2)

    {:ok, "2"} = Query.get("get_set")
  end

  test "strlen/1 with given key" do
    {:ok, "OK"} = Query.set("strlen", "Hello")

    {:ok, "5"} = Query.strlen("strlen")
  end

  test "incr/1 with given key" do
    {:ok, "OK"} = Query.set("incr", 1)

    {:ok, "2"} = Query.incr("incr")
  end

  test "incr_by/2 with given key and value" do
    {:ok, "OK"} = Query.set("incr_by", 1)

    {:ok, "6"} = Query.incr_by("incr_by", 5)    
  end

  test "incr_by_float/2 with given key and value" do
    {:ok, "OK"} = Query.set("incr_by_float", "1.1")

    {:ok, "1.2"} = Query.incr_by_float("incr_by_float", "0.1")
  end

  test "decr/1 with given key" do
    {:ok, "OK"} = Query.set("decr", 1)

    {:ok, "0"} = Query.decr("decr")
  end

  test "decr_by/2 with given key and decrement value" do
    {:ok, "OK"} = Query.set("decr_by", 2)

    {:ok, "1"} = Query.decr_by("decr_by", 1)
  end

  test "mget/2 is list with given keys" do
  	{:ok, "OK"} = Query.set("test:3", "test3value")
  	{:ok, "OK"} = Query.set("test:4", "test4value")

  	mget = Query.mget(["test:3", "test:4"])

  	assert {:ok, ["test3value", "test4value"]} = mget
  end

  test "mset/1 with given keys and values" do
  	mset = Query.mset(["test:5", "test5value", "test:6", "test6value"])

  	assert {:ok, "OK"} = mset
  end

  test "mset_nx/1 with given keys and values" do
    {:ok, "1"} = Query.mset_nx(["msetnx:2", "value", "msetnx:3", "value"])
  end

  test "del/1 with given key" do
  	{:ok, "OK"} = Query.set("test:7", "test7value")

  	del = Query.del("test:7")

  	assert {:ok, "1"} = del
  end

  test "del/1 with given keys" do
  	{:ok, "OK"} = Query.mset(["test:8", "test8value", "test:9", "test9value"])

  	del = Query.del(["test:8", "test:9"])

  	assert {:ok, "2"} = del
  end

  test "lpush/2 with given key and values" do
  	lpush = Query.lpush("list:1", ["value1", "value2"])

  	{:ok, "2"} = lpush
  end 

  test "lpush/2 with given key and value" do
  	lpush = Query.lpush("list:2", "value1")

  	{:ok, "1"} = lpush
  end

  test "lpush/2 with given keys and values pipe funcs" do
    lpush = 
      ["value1", "value2", "value3"]
      |> Query.lpush("list:3")

    assert {:ok, "3"} = lpush
  end 

  test "rpush/2 with given key and values" do
  	rpush = Query.rpush("list:4", ["value1", "value2"])

  	{:ok, "2"} = rpush
  end

  test "rpush/2 with given key and value" do
  	rpush = Query.rpush("list:5", "value2")

  	{:ok, "1"} = rpush
  end

  test "rpush/2 with given key and values pipe funcs" do
    rpush =
      ["value1", "value2", "value3"]
      |> Query.rpush("list:6")

    assert {:ok, "3"} = rpush
  end

  test "lrange/3 with given key and start,stop index" do
  	lpush = Query.lpush("list:7", ["value1", "value2", "value3"])

  	{:ok, "3"} = lpush

  	lrange = Query.lrange("list:7", 0, 1)

  	assert {:ok, ["value3", "value2"]} = lrange
  end

  test "lset/3 with given key and index and value" do
  	lpush = Query.lpush("list:8", ["value1", "value2", "value3"])
  	
  	{:ok, "3"} = lpush

  	lset = Query.lset("list:8", 0, "value4")

  	assert {:ok, "OK"} = lset

  	lrange = Query.lrange("list:8", 0, 1)

 		assert {:ok, ["value4", "value2"]} = lrange
  end

  test "lrem/3 with given key and value count and value" do
  	lpush = Query.lpush("list:9", ["value1", "value2", "value3"])
  	
  	assert {:ok, "3"} = lpush

  	lrem = Query.lrem("list:9", 1, "value3")

  	assert {:ok, "1"} = lrem

  	lrange = Query.lrange("list:9", 0, 1)

  	assert {:ok, ["value2", "value1"]} = lrange
  end

  test "pipe/1 with given queries" do
    {:ok, pipe} = Query.pipe([["SET", "a", 1], ["GET", "a"]])

    assert ["OK", "1"] == pipe
  end
end