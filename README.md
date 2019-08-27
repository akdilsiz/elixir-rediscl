# Elixir Redis Client

A minimal redis client with connection pooling (using eredis and poolboy)

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/58e142f2a26c45528daad73ad3aa03d6)](https://app.codacy.com/app/akdilsiz/elixir-rediscl?utm_source=github.com&utm_medium=referral&utm_content=akdilsiz/elixir-rediscl&utm_campaign=Badge_Grade_Dashboard)
[![Build Status](https://travis-ci.org/akdilsiz/elixir-rediscl.svg?branch=master)](https://travis-ci.org/akdilsiz/elixir-rediscl)
[![Coverage Status](https://coveralls.io/repos/github/akdilsiz/elixir-rediscl/badge.svg?branch=master)](https://coveralls.io/github/akdilsiz/elixir-rediscl?branch=master)
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
config :rediscl,
    host: "127.0.0.1",
    port: 6379,
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
    ### Your codes
    {:ok, pid} = ensure_started(:rediscl, [])

    Rediscl.Query.set("key:1", "value1")

    pid && Rediscl.Superv.stop(pid)
    ### Your codes
end

```

## Contribution

All contributions are welcomed as long as you follow the conventions of *Elixir* language.

## License

MIT