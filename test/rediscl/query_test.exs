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

  test "command/2 keys is list" do
    {:ok, "OK"} = Query.set("keys:1", "value:1")

    command = Query.command("EXPIRE", ["keys:1", 16_000])

    assert {:ok, "1"} = command
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

  test "exists/1 with jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: 1}, %{value: 1}, 
        [{:jsonable, true}, {:encode_key, true}])

    exists = Query.exists(%{key: 1}, [{:jsonable, true}])

    assert {:ok, "1"} == exists
  end

  test "append/2 with given key and value" do
    {:ok, "OK"} = Query.set("append", "Hello")
    
    {:ok, "11"} = Query.append("append", " World")
  end

  test "append/2 with given key and value and jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: 1}, "Hello", [{:jsonable, true}, {:encode_key, true}])
    
    {:ok, "11"} = 
      Query.append(%{key: 1}, " World", [{:jsonable, true}, {:encode_key, true}])
  end

  test "set/2 query with given key and value" do
  	set = Query.set("test:1", 1)

  	assert {:ok, "OK"} = set
  end

  test "set_ex/3 with given key, seconds and value" do
    {:ok, "OK"} = Query.set_ex("setex", 10, "value")
  end

  test "set_ex/3 with given key, seconds and value with jsonable" do
    {:ok, "OK"} = Query.set_ex(%{key: 1}, 10, %{value: 1},
      [{:jsonable, true}, {:encode_key, true}])
  end

  test "set_nx/2 with given key and value" do
    {:ok, "1"} = Query.set_nx("setnx", "value")
  end

  test "set_nx/2 with given key and value and jsonable" do
    {:ok, "1"} = 
      Query.set_nx(%{setnx: 1}, %{value: 1},
        [{:jsonable, true}, {:encode_key, true}])
  end

  test "set_range/3 with given key, offset and value" do
    {:ok, "15"} = Query.set_range("setrange", 10, "value")
  end

  test "set_range/3 with given key, offset and value and jsonable" do
    {:ok, "21"} = 
      Query.set_range(%{key: :setrange}, 10, %{value: 1},
        [{:jsonable, true}, {:encode_key, true}])
  end

  test "pset_ex/3 with given key, miliseconds and value" do
    {:ok, "OK"} = Query.pset_ex("psetex", 1000, "value")
  end

  test "pset_ex/3 with given key, miliseconds and value and jsonable" do
    {:ok, "OK"} = 
      Query.pset_ex(%{key: :psetex}, 1000, "value",
        [{:jsonable, true}, {:encode_key, true}])
  end

  test "get query with given key" do
  	set = Query.set("test:2", %{value: 2}, [{:jsonable, true}])

  	assert {:ok, "OK"} = set

  	get = Query.get("test:2", [{:json_response, true}, 
      {:json_response_opts, [{:keys, :atoms!}]}])

  	assert {:ok, %{value: 2}} = get
  end

  test "get! query with given key" do
    set = Query.set("test:2", 2)

    assert {:ok, "OK"} = set

    get = Query.get!("test:2")

    assert "2" == get
  end

  test "should be InvalidResponseError get! query with given key if key " <>
    "does not exists" do
    error_raise = assert_raise Rediscl.Error.InvalidResponseError, fn -> 
      Query.get!("test:999_999_999")
    end

    assert error_raise.message == :undefined
  end

  test "undefined get query with given key" do
    {:error, :undefined} = Query.get("undefinedkey:1")
  end

  test "get_range/3 with given key, start and stop " do
    {:ok, "OK"} = Query.set("get_range", "Hello World")

    {:ok, "Hello"} = Query.get_range("get_range", 0, 4)
  end

  test "get_range/3 with given key, start and stop and jsonable" do
    {:ok, "OK"} = Query.set(%{key: :getrange}, "Hello World",
      [{:jsonable, true}, {:encode_key, true}])

    {:ok, "Hello"} = 
      Query.get_range(%{key: :getrange}, 0, 4,
        [{:jsonable, true}])
  end

  test "get_set/2 with given key and value" do
    {:ok, "OK"} = Query.set("get_set", 1)

    {:ok, "1"} = Query.get("get_set")

    {:ok, "1"} = Query.get_set("get_set", 2)

    {:ok, "2"} = Query.get("get_set")
  end

  test "get_set/2 with given key and value and jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: :getset}, 1, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = Query.get(%{key: :getset}, [{:jsonable, true}])

    {:ok, "1"} = 
      Query.get_set(%{key: :getset}, 2, 
        [{:jsonable, true}, {:encode_key, true}])

    {:ok, "2"} = Query.get(%{key: :getset}, [{:jsonable, true}])
  end

  test "strlen/1 with given key" do
    {:ok, "OK"} = Query.set("strlen", "Hello")

    {:ok, "5"} = Query.strlen("strlen")
  end

  test "strlen/1 with given key and jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: :strlen}, "Hello", 
        [{:jsonable, true}, {:encode_key, true}])

    {:ok, "5"} = Query.strlen(%{key: :strlen}, [{:jsonable, true}])
  end

  test "incr/1 with given key" do
    {:ok, "OK"} = Query.set("incr", 1)

    {:ok, "2"} = Query.incr("incr")
  end

  test "incr/1 with given key and jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: :incr}, 1, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "2"} = Query.incr(%{key: :incr}, [{:jsonable, true}])
  end

  test "incr_by/2 with given key and value" do
    {:ok, "OK"} = Query.set("incr_by", 1)

    {:ok, "6"} = Query.incr_by("incr_by", 5)    
  end

  test "incr_by/2 with given key and value and jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: :incr_by}, 1, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "6"} = 
      Query.incr_by(%{key: :incr_by}, 5, 
        [{:jsonable, true}, {:encode_key, true}])    
  end

  test "incr_by_float/2 with given key and value" do
    {:ok, "OK"} = Query.set("incr_by_float", "1.1")

    {:ok, "1.2"} = Query.incr_by_float("incr_by_float", "0.1")
  end

  test "incr_by_float/2 with given key and value and jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: :incr_by_float}, "1.1", 
        [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1.2"} = 
      Query.incr_by_float(%{key: :incr_by_float}, "0.1",
        [{:jsonable, true}, {:encode_key, true}])
  end

  test "decr/1 with given key" do
    {:ok, "OK"} = Query.set("decr", 1)

    {:ok, "0"} = Query.decr("decr")
  end

  test "decr/1 with given key with jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: :decr}, 1, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "0"} = Query.decr(%{key: :decr}, [{:jsonable, true}])
  end

  test "decr_by/2 with given key and decrement value" do
    {:ok, "OK"} = Query.set("decr_by", 2)

    {:ok, "1"} = Query.decr_by("decr_by", 1)
  end

  test "decr_by/2 with given key and decrement value and jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: :decr_by}, 2, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = 
      Query.decr_by(%{key: :decr_by}, 1,
        [{:jsonable, true}, {:encode_key, true}])
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

  test "mset_nx/1 with given keys and values and jsonable" do
    {:ok, "1"} = 
      Query.mset_nx([%{key: :msetnx1}, %{value: 1}, 
        %{key: :msetnx2}, %{value: 1}], [{:jsonable, true}])
  end

  test "del/1 with given key" do
  	{:ok, "OK"} = Query.set("test:7", "test7value")

  	del = Query.del("test:7")

  	assert {:ok, "1"} = del
  end

  test "del/1 with given key and jsonable" do
    {:ok, "OK"} = 
      Query.set(%{key: :del7}, "test7value", 
        [{:jsonable, true}, {:encode_key, true}])

    del = Query.del(%{key: :del7}, [{:jsonable, true}])

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

  test "lpush/2 with given key and values and jsonable" do
    lpush = 
      Query.lpush(%{key: :list1}, [%{value: 1}, %{value: 2}],
        [{:jsonable, true}, {:encode_key, true}])

    {:ok, "2"} = lpush
  end 

  test "lpush/2 with given key and value" do
  	lpush = Query.lpush("list:2", "value1")

  	{:ok, "1"} = lpush
  end

  test "lpush/2 with given key and value and jsonable" do
    lpush = 
      Query.lpush(%{key: :list2}, "value2", 
        [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = lpush
  end

  test "rpush/2 with given key and values" do
  	rpush = Query.rpush("list:4", ["value1", "value2"])

  	{:ok, "2"} = rpush
  end

  test "rpush/2 with given key and value" do
  	rpush = Query.rpush("list:5", "value2")

  	{:ok, "1"} = rpush
  end

  test "lrange/3 with given key and start,stop index" do
    lpush = 
      Query.lpush("list:7", ["value1", "value2", "value3"])

    {:ok, "3"} = lpush

    lrange = Query.lrange("list:7", 0, 1)

    assert {:ok, ["value3", "value2"]} = lrange
  end

  test "lrange/3 with given key and start,stop index and json response" do
  	lpush = 
      Query.lpush("list:7", [%{value: 1}, %{value: 2}, %{value: 3}],
        [{:jsonable, true}])

  	{:ok, "3"} = lpush

  	lrange = Query.lrange("list:7", 0, 1, [{:json_response, true}, 
        {:json_response_opts, [{:keys, :atoms!}]}])

  	assert {:ok, [%{value: 3}, %{value: 2}]} = lrange
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

  test "lrem/3 with given key and value count and value and jsonable" do
    lpush = 
      Query.lpush(%{key: :list9}, ["value1", "value2", "value3"],
        [{:jsonable, true}, {:encode_key, true}])
    
    assert {:ok, "3"} = lpush

    lrem = 
      Query.lrem(%{key: :list9}, 1, "value3",
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, "1"} = lrem

    lrange = 
      Query.lrange(%{key: :list9}, 0, 1,
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, ["value2", "value1"]} = lrange
  end

  test "sadd/2 with given key and value" do
    assert {:ok, "1"} == Query.sadd("key:1", ["value1"])
  end

  test "sadd/2 with given key and value and jsonable" do
    assert {:ok, "1"} == 
      Query.sadd(%{key: :sadd}, ["value1"], 
        [{:jsonable, true}, {:encode_key, true}])
  end

  test "sadd/2 with given key and value and jsonable and custom struct" do
    struct = %Rediscl.QueryTestStruct{
      key: 1,
      value: "value"
    }

    assert {:ok, "1"} == 
      Query.sadd(%{key: :sadd}, [struct], 
        [{:jsonable, true}, {:encode_key, true}])
  end

  test "scard/1 with given key" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, "2"} == Query.scard("key:1")
  end

  test "scard/1 with given key wit and jsonable" do
    {:ok, "2"} = 
      Query.sadd(%{key: :scard}, ["value1", "value2"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, "2"} == 
      Query.scard(%{key: :scard}, [{:jsonable, true}])
  end

  test "sdiff/1 with given keys" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])
    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    sdiff = Query.sdiff(["key:1", "key:2"])

    assert {:ok, ["value2"]} == sdiff
  end 

  test "sdiff/1 with given keys and jsonable" do
    {:ok, "2"} = 
      Query.sadd(%{key: 1}, ["value1", "value2"],
        [{:jsonable, true}, {:encode_key, true}])
    {:ok, "1"} = 
      Query.sadd("key:2", ["value1"])

    sdiff = 
      Query.sdiff([%{key: 1}, "key:2"], 
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, ["value2"]} == sdiff
  end 

  test "sdiffstore/2 with given keys" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])
    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    {:ok, "1"} = Query.sdiffstore("key:3", ["key:1", "key:2"])

    assert {:ok, ["value2"]} == Query.smembers("key:3")
  end

  test "sdiffstore/2 with given keys and jsonable" do
    {:ok, "2"} = 
      Query.sadd("key:1", ["value1", "value2"])
    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    {:ok, "1"} = 
      Query.sdiffstore(%{key: :sdiffstore}, ["key:1", "key:2"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, ["value2"]} == 
      Query.smembers(%{key: :sdiffstore}, [{:jsonable, true}])
  end

  test "sinter/1 with given keys" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])
    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    sinter = Query.sinter(["key:1", "key:2"])

    assert {:ok, ["value1"]} == sinter
  end

  test "sinter/1 with given keys and jsonable" do
    {:ok, "2"} = 
      Query.sadd(%{key: 1}, ["value1", "value2"],
        [{:jsonable, true}, {:encode_key, true}])
    {:ok, "1"} = 
      Query.sadd("key:2", ["value1"])

    sinter = 
      Query.sinter([%{key: 1}, "key:2"],
        [{:jsonable, true}])

    assert {:ok, ["value1"]} == sinter
  end

  test "sinterstore/2 with given keys" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])
    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    {:ok, "1"} = Query.sinterstore("key:3", ["key:1", "key:2"])

    assert {:ok, ["value1"]} == Query.smembers("key:3")
  end

  test "sinterstore/2 with given keys and jsonable" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])
    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    {:ok, "1"} = 
      Query.sinterstore(%{key: :sinterstore}, ["key:1", "key:2"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, ["value1"]} == 
      Query.smembers(%{key: :sinterstore}, [{:jsonable, true}])
  end

  test "sismember/2 with given key and value" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, "1"} == Query.sismember("key:1", "value1")
  end

  test "sismember/2 with given key and value and jsonable" do
    {:ok, "2"} = 
      Query.sadd(%{key: :sismember}, ["value1", "value2"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, "1"} == 
      Query.sismember(%{key: :sismember}, "value1",
        [{:jsonable, true}, {:encode_key, true}])
  end

  test "smembers/1 with given key" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, values} = Query.smembers("key:1")
    assert Enum.count(values)
  end

  test "smove/3 with given keys and value" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])
    {:ok, "1"} = Query.sadd("key:2", ["value3"])

    {:ok, "1"} = Query.smove("key:2", "key:1", "value3")

    assert {:ok, values} = Query.smembers("key:1")
    assert Enum.count(values) == 3
  end

  test "smove/3 with given keys and value and jsonable" do
    {:ok, "2"} = 
      Query.sadd(%{key: 1}, ["value1", "value2"],
        [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = 
      Query.sadd(%{key: 2}, ["value3"],
        [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = 
      Query.smove(%{key: 2}, %{key: 1}, "value3",
        [{:jsonable, true}, {:encode_multiple_keys, true}])

    assert {:ok, values} = 
      Query.smembers(%{key: 1}, [{:jsonable, true}])

    assert Enum.count(values) == 3
  end 

  test "spop/2 wih given key and count value" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])

    assert {:ok, _value} = Query.spop("key:1", 1)

    assert {:ok, _values} = Query.smembers("key:1")
  end

  test "spop/2 wih given key and count value and jsonable" do
    {:ok, "3"} = 
      Query.sadd(%{key: :spop}, ["value1", "value2", "value3"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, _value} = 
      Query.spop(%{key: :spop}, 1,
        [{:jsonable, true}])

    assert {:ok, values} = 
      Query.smembers(%{key: :spop}, [{:jsonable, true}])

    assert Enum.count(values) == 2
  end

  test "spop/1 with given key" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])
  
    assert {:ok, _value} = Query.spop("key:1")
  end

  test "spop/1 with given key and jsonable" do
    {:ok, "2"} = 
      Query.sadd(%{key: 1}, ["value1", "value2"],
        [{:jsonable, true}, {:encode_key, true}])
  
    assert {:ok, value} = 
      Query.spop(%{key: 1}, nil, [{:jsonable, true}])
    assert is_binary(value)
  end

  test "srandmember/2 with given key and count value" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])

    assert {:ok, values} = Query.srandmember("key:1", 2)
    assert Enum.count(values) == 2
  end

  test "srandmember/2 with given key and count value and jsonable" do
    {:ok, "3"} = 
      Query.sadd(%{key: 1}, ["value1", "value2", "value3"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, values} = 
      Query.srandmember(%{key: 1}, 2,
        [{:jsonable, true}, {:encode_key, true}])
    assert Enum.count(values) == 2
  end

  test "srandmember/1 with given key" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, value} = Query.srandmember("key:1")
    assert is_binary(value)
  end

  test "srandmember/1 with given key and jsonable" do
    {:ok, "2"} = 
      Query.sadd(%{key: 1}, ["value1", "value2"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, value} = 
      Query.srandmember(%{key: 1}, nil, [{:jsonable, true}])
    assert is_binary(value)
  end

  test "srem/2 with given key and value" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, "1"} == Query.srem("key:1", "value1")
    assert {:ok, ["value2"]} == Query.smembers("key:1")
  end

  test "srem/2 with given key and value and jsonable" do
    {:ok, "2"} = 
      Query.sadd(%{key: 1}, ["value1", %{value: 2}],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, "1"} == 
      Query.srem(%{key: 1}, %{value: 2}, 
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, ["value1"]} == 
      Query.smembers(%{key: 1}, [{:jsonable, true}])
  end

  test "srem/2 with given key and values" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, "2"} == Query.srem("key:1", ["value1", "value2"])
    assert {:ok, []} == Query.smembers("key:1")
  end

  test "srem/2 with given key and values and jsonable" do
    {:ok, "2"} = 
      Query.sadd(%{key: 1}, [%{value: 1}, "value2"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, "2"} == 
      Query.srem(%{key: 1}, [%{value: 1}, "value2"],
        [{:jsonable, true}, {:encode_key, true}])
    assert {:ok, []} == 
      Query.smembers(%{key: 1},
        [{:jsonable, true}])
  end

  test "sscan/2 with given key and values" do
    {:ok, "4"} = 
      Query.sadd("key:1", ["value1", "value2", "oldvalue1", "anohter1"])

    assert {:ok, ["0", ["anohter1"]]} ==
      Query.sscan("key:1", [0, "match", "anohter*"])
  end

  test "sscan/2 with given key and values if key is intger" do
    {:ok, "4"} = 
      Query.sadd(10_000, ["value1", "value2", "oldvalue1", "anohter1"])

    assert {:ok, ["0", ["anohter1"]]} ==
      Query.sscan(10_000, [0, "match", "anohter*"])
  end


  test "sscan/2 with given key and values and jsonable" do
    {:ok, "4"} = 
      Query.sadd(%{key: 1}, ["value1", "value2", "oldvalue1", "anohter1"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, ["0", ["anohter1"]]} ==
      Query.sscan(%{key: 1}, [0, "match", "anohter*"],
        [{:jsonable, true}, {:encode_key, true}])
  end

  test "sunion/1 with given keys" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])
    {:ok, "2"} = Query.sadd("key:2", ["value3", "value1"])

    assert {:ok, values} = Query.sunion(["key:1", "key:2"])
    assert Enum.count(values) == 3
  end

  test "sunion/1 with given keys and jsonable" do
    {:ok, "3"} = 
      Query.sadd(%{key: 1}, ["value1", "value2", "value3"],
        [{:jsonable, true}, {:encode_key, true}])
    {:ok, "2"} = Query.sadd("key:2", ["value3", "value1"])

    assert {:ok, values} = 
      Query.sunion([%{key: 1}, "key:2"],
        [{:jsonable, true}, {:encode_multiple_keys, true}])
    assert Enum.count(values) == 3
  end

  test "sunionstore/2 with given keys" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])
    {:ok, "2"} = Query.sadd("key:2", ["value3", "value1"])

    assert {:ok, "3"} ==
      Query.sunionstore("key:3", ["key:1", "key:2"])

    assert {:ok, values} = Query.smembers("key:3")
    assert Enum.count(values) == 3
  end

  test "sunionstore/2 with given keys and jsonable" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])
    {:ok, "2"} = Query.sadd("key:2", ["value3", "value1"])

    assert {:ok, "3"} ==
      Query.sunionstore(%{key: :sunionstore}, ["key:1", "key:2"],
        [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, values} = 
      Query.smembers(%{key: :sunionstore},
        [{:jsonable, true}])
    assert Enum.count(values) == 3
  end

  test "sunionstore/2 with given keys and jsonable multiple key" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])
    {:ok, "2"} = Query.sadd("key:2", ["value3", "value1"])

    assert {:ok, "3"} ==
      Query.sunionstore(%{key: :sunionstore}, ["key:1", "key:2"],
        [{:jsonable, true}, {:encode_multiple_keys, true}])

    assert {:ok, values} = 
      Query.smembers(%{key: :sunionstore},
        [{:jsonable, true}])
    assert Enum.count(values) == 3
  end

  test "pipe/1 with given queries" do
    {:ok, pipe} = Query.pipe([["SET", "a", 1], ["GET", "a"]])

    assert ["OK", "1"] == pipe
  end
end