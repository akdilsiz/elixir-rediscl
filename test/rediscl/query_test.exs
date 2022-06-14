defmodule Rediscl.QueryTest do
  use ExUnit.Case, [async: true]
  doctest Rediscl

  alias Rediscl.Query
  import Rediscl.Query.Pipe

  setup do
    {:ok, keys} = Query.command("KEYS", "*")

    Query.del(keys)

    :ok
  end

  test "run_pipe/1" do
    query =
      begin(
        set: ["key:10", "1"],
        set: ["key:1234", "1234"],
        mset: ["key:11", "value2", "key:12", "value3"],
        lpush: ["key:13", ["-1", "-2", "-3"]],
        rpush: ["key:14", ["1", "2", "3"]],
        lrange: ["key:13", 0, "-1"],
        lrem: ["key:13", 1, "-1"]
      )

    assert {:ok, _results} = Query.run_pipe(query)
  end

  test "run_pipe/1 other commands" do
    query =
      begin(
        set: ["key:10", 10],
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
      )

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

    assert {:error, _} = command
  end

  test "exists/1" do
    {:ok, "OK"} = Query.set("exists", "1")

    exists = Query.exists("exists")

    assert {:ok, "1"} == exists
  end

  test "exists/1 with jsonable" do
    {:ok, "OK"} = Query.set(%{key: 1}, %{value: 1}, [{:jsonable, true}, {:encode_key, true}])

    exists = Query.exists(%{key: 1}, [{:jsonable, true}])

    assert {:ok, "1"} == exists
  end

  test "append/2 with given key and value" do
    {:ok, "OK"} = Query.set("append", "Hello")

    {:ok, "11"} = Query.append("append", " World")
  end

  test "append/2 with given key and value and jsonable" do
    {:ok, "OK"} = Query.set(%{key: 1}, "Hello", [{:jsonable, true}, {:encode_key, true}])

    {:ok, "11"} = Query.append(%{key: 1}, " World", [{:jsonable, true}, {:encode_key, true}])
  end

  test "set/2 query with given key and value" do
    set = Query.set("test:1", 1)

    assert {:ok, "OK"} = set
  end

  test "set_ex/3 with given key, seconds and value" do
    {:ok, "OK"} = Query.set_ex("setex", 10, "value")
  end

  test "set_ex/3 with given key, seconds and value with jsonable" do
    {:ok, "OK"} =
      Query.set_ex(%{key: 1}, 10, %{value: 1}, [{:jsonable, true}, {:encode_key, true}])
  end

  test "set_nx/2 with given key and value" do
    {:ok, "1"} = Query.set_nx("setnx", "value")
  end

  test "set_nx/2 with given key and value and jsonable" do
    {:ok, "1"} = Query.set_nx(%{setnx: 1}, %{value: 1}, [{:jsonable, true}, {:encode_key, true}])
  end

  test "set_range/3 with given key, offset and value" do
    {:ok, "15"} = Query.set_range("setrange", 10, "value")
  end

  test "set_range/3 with given key, offset and value and jsonable" do
    {:ok, "21"} =
      Query.set_range(%{key: :setrange}, 10, %{value: 1}, [{:jsonable, true}, {:encode_key, true}])
  end

  test "pset_ex/3 with given key, miliseconds and value" do
    {:ok, "OK"} = Query.pset_ex("psetex", 1000, "value")
  end

  test "pset_ex/3 with given key, miliseconds and value and jsonable" do
    {:ok, "OK"} =
      Query.pset_ex(%{key: :psetex}, 1000, "value", [{:jsonable, true}, {:encode_key, true}])
  end

  test "get query with given key" do
    set = Query.set("test:2", %{value: 2}, [{:jsonable, true}])

    assert {:ok, "OK"} = set

    get = Query.get("test:2", [{:json_response, true}, {:json_response_opts, [{:keys, :atoms!}]}])

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
    error_raise =
      assert_raise Rediscl.Error.InvalidResponseError, fn ->
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
    {:ok, "OK"} =
      Query.set(%{key: :getrange}, "Hello World", [{:jsonable, true}, {:encode_key, true}])

    {:ok, "Hello"} = Query.get_range(%{key: :getrange}, 0, 4, [{:jsonable, true}])
  end

  test "get_set/2 with given key and value" do
    {:ok, "OK"} = Query.set("get_set", 1)

    {:ok, "1"} = Query.get("get_set")

    {:ok, "1"} = Query.get_set("get_set", 2)

    {:ok, "2"} = Query.get("get_set")
  end

  test "get_set/2 with given key and value and jsonable" do
    {:ok, "OK"} = Query.set(%{key: :getset}, 1, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = Query.get(%{key: :getset}, [{:jsonable, true}])

    {:ok, "1"} = Query.get_set(%{key: :getset}, 2, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "2"} = Query.get(%{key: :getset}, [{:jsonable, true}])
  end

  test "strlen/1 with given key" do
    {:ok, "OK"} = Query.set("strlen", "Hello")

    {:ok, "5"} = Query.strlen("strlen")
  end

  test "strlen/1 with given key and jsonable" do
    {:ok, "OK"} = Query.set(%{key: :strlen}, "Hello", [{:jsonable, true}, {:encode_key, true}])

    {:ok, "5"} = Query.strlen(%{key: :strlen}, [{:jsonable, true}])
  end

  test "incr/1 with given key" do
    {:ok, "OK"} = Query.set("incr", 1)

    {:ok, "2"} = Query.incr("incr")
  end

  test "incr/1 with given key and jsonable" do
    {:ok, "OK"} = Query.set(%{key: :incr}, 1, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "2"} = Query.incr(%{key: :incr}, [{:jsonable, true}])
  end

  test "incr_by/2 with given key and value" do
    {:ok, "OK"} = Query.set("incr_by", 1)

    {:ok, "6"} = Query.incr_by("incr_by", 5)
  end

  test "incr_by/2 with given key and value and jsonable" do
    {:ok, "OK"} = Query.set(%{key: :incr_by}, 1, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "6"} = Query.incr_by(%{key: :incr_by}, 5, [{:jsonable, true}, {:encode_key, true}])
  end

  test "incr_by_float/2 with given key and value" do
    {:ok, "OK"} = Query.set("incr_by_float", "1.1")

    {:ok, "1.2"} = Query.incr_by_float("incr_by_float", "0.1")
  end

  test "incr_by_float/2 with given key and value and jsonable" do
    {:ok, "OK"} =
      Query.set(%{key: :incr_by_float}, "1.1", [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1.2"} =
      Query.incr_by_float(%{key: :incr_by_float}, "0.1", [{:jsonable, true}, {:encode_key, true}])
  end

  test "decr/1 with given key" do
    {:ok, "OK"} = Query.set("decr", 1)

    {:ok, "0"} = Query.decr("decr")
  end

  test "decr/1 with given key with jsonable" do
    {:ok, "OK"} = Query.set(%{key: :decr}, 1, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "0"} = Query.decr(%{key: :decr}, [{:jsonable, true}])
  end

  test "decr_by/2 with given key and decrement value" do
    {:ok, "OK"} = Query.set("decr_by", 2)

    {:ok, "1"} = Query.decr_by("decr_by", 1)
  end

  test "decr_by/2 with given key and decrement value and jsonable" do
    {:ok, "OK"} = Query.set(%{key: :decr_by}, 2, [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = Query.decr_by(%{key: :decr_by}, 1, [{:jsonable, true}, {:encode_key, true}])
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
      Query.mset_nx(
        [%{key: :msetnx1}, %{value: 1}, %{key: :msetnx2}, %{value: 1}],
        [{:jsonable, true}]
      )
  end

  test "del/1 with given key" do
    {:ok, "OK"} = Query.set("test:7", "test7value")

    del = Query.del("test:7")

    assert {:ok, "1"} = del
  end

  test "del/1 with given key and jsonable" do
    {:ok, "OK"} = Query.set(%{key: :del7}, "test7value", [{:jsonable, true}, {:encode_key, true}])

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
      Query.lpush(%{key: :list1}, [%{value: 1}, %{value: 2}], [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "2"} = lpush
  end

  test "lpush/2 with given key and value" do
    lpush = Query.lpush("list:2", "value1")

    {:ok, "1"} = lpush
  end

  test "lpush/2 with given key and value and jsonable" do
    lpush = Query.lpush(%{key: :list2}, "value2", [{:jsonable, true}, {:encode_key, true}])

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
    lpush = Query.lpush("list:7", ["value1", "value2", "value3"])

    {:ok, "3"} = lpush

    lrange = Query.lrange("list:7", 0, 1)

    assert {:ok, ["value3", "value2"]} = lrange
  end

  test "lrange/3 with given key and start,stop index and json response" do
    lpush = Query.lpush("list:7", [%{value: 1}, %{value: 2}, %{value: 3}], [{:jsonable, true}])

    {:ok, "3"} = lpush

    lrange =
      Query.lrange("list:7", 0, 1, [
        {:json_response, true},
        {:json_response_opts, [{:keys, :atoms!}]}
      ])

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
      Query.lpush(%{key: :list9}, ["value1", "value2", "value3"], [
        {:jsonable, true},
        {:encode_key, true}
      ])

    assert {:ok, "3"} = lpush

    lrem = Query.lrem(%{key: :list9}, 1, "value3", [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, "1"} = lrem

    lrange = Query.lrange(%{key: :list9}, 0, 1, [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, ["value2", "value1"]} = lrange
  end

  test "sadd/2 with given key and value" do
    assert {:ok, "1"} == Query.sadd("key:1", ["value1"])
  end

  test "sadd/2 with given key and value and jsonable" do
    assert {:ok, "1"} ==
             Query.sadd(%{key: :sadd}, ["value1"], [{:jsonable, true}, {:encode_key, true}])
  end

  test "sadd/2 with given key and value and jsonable and custom struct" do
    struct = %Rediscl.QueryTestStruct{
      key: 1,
      value: "value"
    }

    assert {:ok, "1"} ==
             Query.sadd(%{key: :sadd}, [struct], [{:jsonable, true}, {:encode_key, true}])
  end

  test "scard/1 with given key" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, "2"} == Query.scard("key:1")
  end

  test "scard/1 with given key wit and jsonable" do
    {:ok, "2"} =
      Query.sadd(%{key: :scard}, ["value1", "value2"], [{:jsonable, true}, {:encode_key, true}])

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
      Query.sadd(%{key: 1}, ["value1", "value2"], [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    sdiff =
      Query.sdiff(
        [%{key: 1}, "key:2"],
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, ["value2"]} == sdiff
  end

  test "sdiffstore/2 with given keys" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])
    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    {:ok, "1"} = Query.sdiffstore("key:3", ["key:1", "key:2"])

    assert {:ok, ["value2"]} == Query.smembers("key:3")
  end

  test "sdiffstore/2 with given keys and jsonable" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])
    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    {:ok, "1"} =
      Query.sdiffstore(%{key: :sdiffstore}, ["key:1", "key:2"], [
        {:jsonable, true},
        {:encode_key, true}
      ])

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
      Query.sadd(%{key: 1}, ["value1", "value2"], [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = Query.sadd("key:2", ["value1"])

    sinter =
      Query.sinter(
        [%{key: 1}, "key:2"],
        [{:jsonable, true}]
      )

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
      Query.sinterstore(%{key: :sinterstore}, ["key:1", "key:2"], [
        {:jsonable, true},
        {:encode_key, true}
      ])

    assert {:ok, ["value1"]} ==
             Query.smembers(%{key: :sinterstore}, [{:jsonable, true}])
  end

  test "sismember/2 with given key and value" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, "1"} == Query.sismember("key:1", "value1")
  end

  test "sismember/2 with given key and value and jsonable" do
    {:ok, "2"} =
      Query.sadd(%{key: :sismember}, ["value1", "value2"], [
        {:jsonable, true},
        {:encode_key, true}
      ])

    assert {:ok, "1"} ==
             Query.sismember(%{key: :sismember}, "value1", [
               {:jsonable, true},
               {:encode_key, true}
             ])
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
      Query.sadd(%{key: 1}, ["value1", "value2"], [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} = Query.sadd(%{key: 2}, ["value3"], [{:jsonable, true}, {:encode_key, true}])

    {:ok, "1"} =
      Query.smove(%{key: 2}, %{key: 1}, "value3", [
        {:jsonable, true},
        {:encode_multiple_keys, true}
      ])

    assert {:ok, values} = Query.smembers(%{key: 1}, [{:jsonable, true}])

    assert Enum.count(values) == 3
  end

  test "spop/2 wih given key and count value" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])

    assert {:ok, _value} = Query.spop("key:1", 1)

    assert {:ok, _values} = Query.smembers("key:1")
  end

  test "spop/2 wih given key and count value and jsonable" do
    {:ok, "3"} =
      Query.sadd(%{key: :spop}, ["value1", "value2", "value3"], [
        {:jsonable, true},
        {:encode_key, true}
      ])

    assert {:ok, _value} = Query.spop(%{key: :spop}, 1, [{:jsonable, true}])

    assert {:ok, values} = Query.smembers(%{key: :spop}, [{:jsonable, true}])

    assert Enum.count(values) == 2
  end

  test "spop/1 with given key" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, _value} = Query.spop("key:1")
  end

  test "spop/1 with given key and jsonable" do
    {:ok, "2"} =
      Query.sadd(%{key: 1}, ["value1", "value2"], [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, value} = Query.spop(%{key: 1}, nil, [{:jsonable, true}])
    assert is_binary(value)
  end

  test "srandmember/2 with given key and count value" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])

    assert {:ok, values} = Query.srandmember("key:1", 2)
    assert Enum.count(values) == 2
  end

  test "srandmember/2 with given key and count value and jsonable" do
    {:ok, "3"} =
      Query.sadd(%{key: 1}, ["value1", "value2", "value3"], [
        {:jsonable, true},
        {:encode_key, true}
      ])

    assert {:ok, values} =
             Query.srandmember(%{key: 1}, 2, [{:jsonable, true}, {:encode_key, true}])

    assert Enum.count(values) == 2
  end

  test "srandmember/1 with given key" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, value} = Query.srandmember("key:1")
    assert is_binary(value)
  end

  test "srandmember/1 with given key and jsonable" do
    {:ok, "2"} =
      Query.sadd(%{key: 1}, ["value1", "value2"], [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, value} = Query.srandmember(%{key: 1}, nil, [{:jsonable, true}])
    assert is_binary(value)
  end

  test "srem/2 with given key and value" do
    {:ok, "2"} = Query.sadd("key:1", ["value1", "value2"])

    assert {:ok, "1"} == Query.srem("key:1", "value1")
    assert {:ok, ["value2"]} == Query.smembers("key:1")
  end

  test "srem/2 with given key and value and jsonable" do
    {:ok, "2"} =
      Query.sadd(%{key: 1}, ["value1", %{value: 2}], [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, "1"} ==
             Query.srem(%{key: 1}, %{value: 2}, [{:jsonable, true}, {:encode_key, true}])

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
      Query.sadd(%{key: 1}, [%{value: 1}, "value2"], [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, "2"} ==
             Query.srem(%{key: 1}, [%{value: 1}, "value2"], [
               {:jsonable, true},
               {:encode_key, true}
             ])

    assert {:ok, []} ==
             Query.smembers(
               %{key: 1},
               [{:jsonable, true}]
             )
  end

  test "sscan/2 with given key and values" do
    {:ok, "4"} = Query.sadd("key:1", ["value1", "value2", "oldvalue1", "anohter1"])

    assert {:ok, ["0", ["anohter1"]]} ==
             Query.sscan("key:1", [0, "match", "anohter*"])
  end

  test "sscan/2 with given key and values if key is intger" do
    {:ok, "4"} = Query.sadd(10_000, ["value1", "value2", "oldvalue1", "anohter1"])

    assert {:ok, ["0", ["anohter1"]]} ==
             Query.sscan(10_000, [0, "match", "anohter*"])
  end

  test "sscan/2 with given key and values and jsonable" do
    {:ok, "4"} =
      Query.sadd(%{key: 1}, ["value1", "value2", "oldvalue1", "anohter1"], [
        {:jsonable, true},
        {:encode_key, true}
      ])

    assert {:ok, ["0", ["anohter1"]]} ==
             Query.sscan(%{key: 1}, [0, "match", "anohter*"], [
               {:jsonable, true},
               {:encode_key, true}
             ])
  end

  test "sunion/1 with given keys" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])
    {:ok, "2"} = Query.sadd("key:2", ["value3", "value1"])

    assert {:ok, values} = Query.sunion(["key:1", "key:2"])
    assert Enum.count(values) == 3
  end

  test "sunion/1 with given keys and jsonable" do
    {:ok, "3"} =
      Query.sadd(%{key: 1}, ["value1", "value2", "value3"], [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "2"} = Query.sadd("key:2", ["value3", "value1"])

    assert {:ok, values} =
             Query.sunion(
               [%{key: 1}, "key:2"],
               [{:jsonable, true}, {:encode_multiple_keys, true}]
             )

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
             Query.sunionstore(%{key: :sunionstore}, ["key:1", "key:2"], [
               {:jsonable, true},
               {:encode_key, true}
             ])

    assert {:ok, values} =
             Query.smembers(
               %{key: :sunionstore},
               [{:jsonable, true}]
             )

    assert Enum.count(values) == 3
  end

  test "sunionstore/2 with given keys and jsonable multiple key" do
    {:ok, "3"} = Query.sadd("key:1", ["value1", "value2", "value3"])
    {:ok, "2"} = Query.sadd("key:2", ["value3", "value1"])

    assert {:ok, "3"} ==
             Query.sunionstore(%{key: :sunionstore}, ["key:1", "key:2"], [
               {:jsonable, true},
               {:encode_multiple_keys, true}
             ])

    assert {:ok, values} =
             Query.smembers(
               %{key: :sunionstore},
               [{:jsonable, true}]
             )

    assert Enum.count(values) == 3
  end

  test "zadd/3 with given key and score and value" do
    assert {:ok, "1"} = Query.zadd("key:1", 1, "value1")
  end

  test "zadd/3 with given key and score and value and jsonable" do
    assert {:ok, "1"} =
             Query.zadd(%{key: :key}, 1, %{value: :value}, [
               {:jsonable, true},
               {:encode_key, true}
             ])
  end

  test "zcard/1 with given key" do
    {:ok, "1"} = Query.zadd("key:1", 1, "value1")

    assert {:ok, "1"} = Query.zcard("key:1")
  end

  test "zcard/1 with given key and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 1, %{value: :value}, [{:jsonable, true}, {:encode_key, true}])

    assert {:ok, "1"} = Query.zcard(%{key: :key}, [{:jsonable, true}, {:encode_key, true}])
  end

  test "zcount/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 1, "value1")
    {:ok, "1"} = Query.zadd("key:1", 2, "value2")

    assert {:ok, "2"} = Query.zcount("key:1", 1, 2)
  end

  test "zcount/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 1, %{value: :value1}, [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 2, %{value: :value2}, [
        {:jsonable, true},
        {:encode_key, true}
      ])

    assert {:ok, "2"} =
             Query.zcount(%{key: :key}, 1, 2, [
               {:jsonable, true},
               {:encode_key, true}
             ])
  end

  test "zincrby/3 with given key and increment and value" do
    {:ok, "1"} = Query.zadd("key:1", 1, "value1")
    assert {:ok, "6"} = Query.zincrby("key:1", 5, "value1")
  end

  test "zincrby/3 with given key and increment and value and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 1, %{value: :value}, [
        {:jsonable, true},
        {:encode_key, true}
      ])

    assert {:ok, "6"} =
             Query.zincrby(%{key: :key}, 5, %{value: :value}, [
               {:jsonable, true},
               {:encode_key, true}
             ])
  end

  test "zinter/1 with given keys" do
    {:ok, "1"} = Query.zadd("key:1", 1, "value1")
    {:ok, "1"} = Query.zadd("key:2", 1, "value1")
    {:ok, "1"} = Query.zadd("key:2", 2, "value2")

    zinter = Query.zinter(["key:1", "key:2"])

    assert {:ok, ["value1"]} == zinter
  end

  test "zinter/1 with given keys and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key1}, 1, "value1", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key2}, 1, "value1", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key2}, 2, "value2", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zinter =
      Query.zinter(
        [%{key: :key1}, %{key: :key2}],
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, ["value1"]} == zinter
  end

  test "zinterstore/2 with given keys" do
    {:ok, "1"} = Query.zadd("key:1", 1, "value1")
    {:ok, "1"} = Query.zadd("key:2", 1, "value1")
    {:ok, "1"} = Query.zadd("key:2", 2, "value2")

    zinterstore = Query.zinterstore("out", ["key:1", "key:2"])

    assert {:ok, "1"} == zinterstore
  end

  test "zinterstore/2 with given keys and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key1}, 1, %{value: :value1}, [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key2}, 1, %{value: :value1}, [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key2}, 2, %{value: :value2}, [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zinterstore =
      Query.zinterstore(
        %{key: :out},
        [%{key: :key1}, %{key: :key2}],
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "1"} == zinterstore
  end

  test "zlexcount/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, "3"} = Query.zlexcount("key:1", "[a", "[c")
  end

  test "zlexcount/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zlexcount =
      Query.zlexcount(
        [%{key: :key}],
        "[a",
        "[c",
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "3"} == zlexcount
  end

  test "zrange/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, ["a", "b", "c"]} = Query.zrange("key:1", 0, -1)
  end

  test "zrange/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zrange =
      Query.zrange(
        [%{key: :key}],
        0,
        -1,
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, ["a", "b", "c"]} == zrange
  end

  test "zrangebylex/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, ["a", "b", "c"]} = Query.zrangebylex("key:1", "[a", "[c")
  end

  test "zrangebylex/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zrangebylex =
      Query.zrangebylex(
        [%{key: :key}],
        "[a",
        "[c",
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, ["a", "b", "c"]} == zrangebylex
  end

  test "zrangebyscore/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, ["a", "b", "c"]} = Query.zrangebyscore("key:1", 0, 0)
  end

  test "zrangebyscore/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zrangebyscore =
      Query.zrangebyscore(
        [%{key: :key}],
        0,
        0,
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, ["a", "b", "c"]} == zrangebyscore
  end

  test "zrank/3 with given key and value" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, "0"} = Query.zrank("key:1", "a")
  end

  test "zrank/3 with given key and value and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zrank =
      Query.zrank(
        [%{key: :key}],
        "b",
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "1"} == zrank
  end

  test "zrem/3 with given key and value" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")

    {:ok, "1"} = Query.zrem("key:1", "a")
  end

  test "zrem/3 with given key and value and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zrem =
      Query.zrem(
        [%{key: :key}],
        "a",
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "1"} == zrem
  end

  test "zremrangebylex/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, "3"} = Query.zremrangebylex("key:1", "[a", "[c")
  end

  test "zremrangebylex/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zremrangebylex =
      Query.zremrangebylex(
        [%{key: :key}],
        "[a",
        "[c",
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "3"} == zremrangebylex
  end

  test "zremrangebyrank/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, "3"} = Query.zremrangebyrank("key:1", 0, 2)
  end

  test "zremrangebyrank/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zremrangebyrank =
      Query.zremrangebyrank(
        [%{key: :key}],
        0,
        2,
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "3"} == zremrangebyrank
  end

  test "zremrangebyscore/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, "3"} = Query.zremrangebyscore("key:1", 0, 0)
  end

  test "zremrangebyscore/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zremrangebyscore =
      Query.zremrangebyscore(
        [%{key: :key}],
        0,
        0,
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "3"} == zremrangebyscore
  end

  test "zrevrange/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, ["c", "b", "a"]} = Query.zrevrange("key:1", 0, -1)
  end

  test "zrevrange/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zrevrange =
      Query.zrevrange(
        [%{key: :key}],
        0,
        -1,
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, ["c", "b", "a"]} == zrevrange
  end

  test "zrevrangebylex/3 with given key and max and min" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, ["c", "b", "a"]} = Query.zrevrangebylex("key:1", "[c", "[a")
  end

  test "zrevrangebylex/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zrevrangebylex =
      Query.zrevrangebylex(
        [%{key: :key}],
        "[c",
        "[a",
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, ["c", "b", "a"]} == zrevrangebylex
  end

  test "zrevrangebyscore/3 with given key and min and max" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, ["c", "b", "a"]} = Query.zrevrangebyscore("key:1", 0, 0)
  end

  test "zrevrangebyscore/3 with given key and min and max and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zrevrangebyscore =
      Query.zrevrangebyscore(
        [%{key: :key}],
        0,
        0,
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, ["c", "b", "a"]} == zrevrangebyscore
  end

  test "zrevrank/3 with given key and value" do
    {:ok, "1"} = Query.zadd("key:1", 0, "a")
    {:ok, "1"} = Query.zadd("key:1", 0, "b")
    {:ok, "1"} = Query.zadd("key:1", 0, "c")

    {:ok, "2"} = Query.zrevrank("key:1", "a")
  end

  test "zrevrank/3 with given key and value and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "b", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :key}, 0, "c", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zrevrank =
      Query.zrevrank(
        [%{key: :key}],
        "a",
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "2"} == zrevrank
  end

  test "zscore/3 with given key and value" do
    {:ok, "1"} = Query.zadd("key:1", 4, "a")

    {:ok, "4"} = Query.zscore("key:1", "a")
  end

  test "zscore/3 with given key and value and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :key}, 4, "a", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zscore =
      Query.zscore(
        [%{key: :key}],
        "a",
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "4"} == zscore
  end

  test "zunion/1 with given keys" do
    {:ok, "1"} = Query.zadd("keyz:1", 1, "value1")
    {:ok, "1"} = Query.zadd("keyz:2", 1, "value1")
    {:ok, "1"} = Query.zadd("keyz:2", 2, "value2")

    zunion = Query.zunion(["keyz:1", "keyz:2"])

    assert {:ok, ["value1", "value2"]} == zunion
  end

  test "zunion/1 with given keys and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :keyzz1}, 1, "value1", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :keyzz2}, 1, "value1", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :keyzz2}, 2, "value2", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zunion =
      Query.zunion(
        [%{key: :keyzz1}, %{key: :keyzz2}],
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, ["value1", "value2"]} == zunion
  end

  test "zunionstore/2 with given keys" do
    {:ok, "1"} = Query.zadd("keyzzz:1", 1, "value1")
    {:ok, "1"} = Query.zadd("keyzzz:2", 1, "value1")
    {:ok, "1"} = Query.zadd("keyzzz:2", 2, "value2")

    zunionstore = Query.zunionstore("out", ["keyzzz:1", "keyzzz:2"])

    assert {:ok, "2"} == zunionstore
  end

  test "zunionstore/2 with given keys and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: :keyy1}, 1, %{value: :value1}, [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :keyy2}, 1, %{value: :value1}, [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: :keyy2}, 2, %{value: :value2}, [
        {:jsonable, true},
        {:encode_key, true}
      ])

    zunionstore =
      Query.zunionstore(
        %{key: :out},
        [%{key: :keyy1}, %{key: :keyy2}],
        [{:jsonable, true}, {:encode_key, true}]
      )

    assert {:ok, "2"} == zunionstore
  end

  test "zscan/2 with given key and values" do
    {:ok, "1"} = Query.zadd("keysc:1", 1, "value1")
    {:ok, "1"} = Query.zadd("keysc:1", 1, "value2")
    {:ok, "1"} = Query.zadd("keysc:1", 1, "oldvalue1")
    {:ok, "1"} = Query.zadd("keysc:1", 1, "anohter1")

    assert {:ok, ["0", ["anohter1", "1"]]} ==
             Query.zscan("keysc:1", [0, "match", "anohter*"])
  end

  test "zscan/2 with given key and values if key is integer" do
    {:ok, "1"} = Query.zadd(10_000, 1, "value1")
    {:ok, "1"} = Query.zadd(10_000, 1, "value2")
    {:ok, "1"} = Query.zadd(10_000, 1, "oldvalue1")
    {:ok, "1"} = Query.zadd(10_000, 1, "anohter1")

    assert {:ok, ["0", ["anohter1", "1"]]} ==
             Query.zscan(10_000, [0, "match", "anohter*"])
  end

  test "zscan/2 with given key and values and jsonable" do
    {:ok, "1"} =
      Query.zadd(%{key: 123}, 1, "value1", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: 123}, 1, "value2", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: 123}, 1, "oldvalue1", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    {:ok, "1"} =
      Query.zadd(%{key: 123}, 1, "anohter1", [
        {:jsonable, true},
        {:encode_key, true}
      ])

    assert {:ok, ["0", ["anohter1", "1"]]} ==
             Query.zscan(%{key: 123}, [0, "match", "anohter*"], [
               {:jsonable, true},
               {:encode_key, true}
             ])
  end

  test "pipe/1 with given queries" do
    {:ok, pipe} = Query.pipe([["SET", "a", 1], ["GET", "a"]])

    assert ["OK", "1"] == pipe
  end
end
