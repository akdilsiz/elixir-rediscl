# Elixir Redis Client

Minimal Redis client
[![Build Status](https://travis-ci.com/akdilsiz/elixir-rediscl.svg?branch=master)](https://travis-ci.com/akdilsiz/elixir-rediscl)
[![Coverage Status](https://coveralls.io/repos/github/akdilsiz/elixir-rediscl/badge.svg?branch=master)](https://coveralls.io/github/akdilsiz/elixir-rediscl?branch=master)

**TODO: Complete docs**

## Installation
[available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rediscl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rediscl, "~> 0.1.0"}
  ]
end
```

## Documentation
[available HexDocs](https://hexdocs.pm).

## Configuration

```elixir
config :rediscl,
    host: "127.0.0.1",
    port: 6379,
    database: 0,
    pool: 15,
    timeout: 15_000
```

## Contribution

All contributions are welcomed as long as you follow the conventions of *Elixir* language.

## License

MIT