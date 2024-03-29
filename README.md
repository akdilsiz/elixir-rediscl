# Elixir Redis Client

A minimal redis client with connection pooling  

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/58e142f2a26c45528daad73ad3aa03d6)](https://app.codacy.com/app/akdilsiz/elixir-rediscl?utm_source=github.com&utm_medium=referral&utm_content=akdilsiz/elixir-rediscl&utm_campaign=Badge_Grade_Dashboard)
[![CircleCI](https://circleci.com/gh/akdilsiz/elixir-rediscl/tree/master.svg?style=svg)](https://circleci.com/gh/akdilsiz/elixir-rediscl/tree/master)
[![Coverage Status](https://coveralls.io/repos/github/akdilsiz/elixir-rediscl/badge.svg)](https://coveralls.io/github/akdilsiz/elixir-rediscl)
[![Hex.pm](https://img.shields.io/hexpm/v/rediscl.svg)](https://hex.pm/packages/rediscl)
[![Hex.pm](https://img.shields.io/hexpm/dt/rediscl.svg)](https://hex.pm/packages/rediscl)

##TODO List
- [ ] Completed docs 
- [ ] All redis commands will be added.

## Features
- Connection pooling
- Pipe query builder (basic commands)
- Basic Query commands

## Installation
[available in Hex](https://hex.pm/packages/rediscl), the package can be installed
by adding `rediscl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rediscl, "~> 0.1"}
  ]
end
```

## Documentation
[available HexDocs](https://hexdocs.pm/rediscl).

## Configuration

```elixir
# Without password
config :rediscl,
    host: {127, 0, 0, 1},
    port: 6379,
    database: 0,
    pool: 15,
    timeout: 15_000

# With password
config :rediscl,
    host: {127, 0, 0, 1},
    port: 6379,
    password: "<password>",
    database: 0,
    pool: 15,
    timeout: 15_000
```

If do you are using json library?
```elixir
config :rediscl,
  json_library: Jason
```

## Examples
```elixir
defmodule Example do
    alias Rediscl

    def example_one do
        {:ok, _} = Rediscl.Query.set("key:1", "value1")
    end

    def example_two do
        {:ok, value} = Rediscl.Query.get("key:1")
    end

    def example_three do
        {:ok, list_values} = Rediscl.Query.mget(["key:1", "key:2", "key:3"])
    end

    def example_jsonable_one do
      ## If you are only going to use it with a key for response
      ## For this example, options are given based on the Jason library.
      {:ok, _} =
        Rediscl.Query.get(%{key: 1}, 
          [{:json_response, true}, {:json_response_opts, [{:keys, :atoms!}]}])
    end
    
    def example_jsonable_two do
      ## If you are only going to use it with key and value.
      {:ok, _} =
        Rediscl.Query.set(%{key: 1}, %{value: 1}, 
          [{:jsonable, true}, {:encode_key, true}])
    end

    def example_jsonable_three do
      ## If you're going to use a query with a lot of keys and a value.
      {:ok, _} =
        Query.smove(%{key: 2}, %{key: 1}, "value3",
          [{:jsonable, true}, {:encode_multiple_keys, true}])
    end

    def example_jsonable_four do
      ## If you're going to use a query with a lot of keys.
      {:ok, _values} = 
        Query.sunion([%{key: 1}, "key:2"],
          [{:jsonable, true}, {:encode_multiple_keys, true}])
    end    
end

defmodule ExamplePipeBuilder do
    import Rediscl.Query.Pipe
    alias Rediscl.Query

    def example do
        query = begin set: ["key:10", "1"],
                      mset: ["key:11", "value2", "key:12", "value3"],
                      lpush: ["key:13", ["-1", "-2", "-3"]],
                      rpush: ["key:14", ["1", "2", "3"]],
                      lrange: ["key:13", 0, "-1"],
                      lrem: ["key:13", 1, "-1"]

        {:ok, results} = Query.run_pipe(query)
    end
end
```

## Use rediscl for Mix.Task
```elixir
import Mix.Rediscl
alias Rediscl

def run(_) do
    Mix.Task.run "app.start"
    
    ### Your codes
    Rediscl.Query.set("key:1", "value1")
    ### Your codes
end

```

## Contribution

All contributions are welcomed as long as you follow the conventions of *Elixir* language.

## License

MIT