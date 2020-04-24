##
# 	Prepared by github.com/Chatatata.
##
defprotocol(Rediscl.Typeable, do: def(typeof(self)))
defimpl(Rediscl.Typeable, for: Atom, do: def(typeof(_), do: "atom"))
defimpl(Rediscl.Typeable, for: BitString, do: def(typeof(_), do: "string"))
defimpl(Rediscl.Typeable, for: Float, do: def(typeof(_), do: "float"))
defimpl(Rediscl.Typeable, for: Decimal, do: def(typeof(_), do: "decimal"))
defimpl(Rediscl.Typeable, for: Function, do: def(typeof(_), do: "Function"))
defimpl(Rediscl.Typeable, for: Integer, do: def(typeof(_), do: "integer"))
defimpl(Rediscl.Typeable, for: List, do: def(typeof(_), do: "list"))
defimpl(Rediscl.Typeable, for: Map, do: def(typeof(_), do: "map"))
defimpl(Rediscl.Typeable, for: PID, do: def(typeof(_), do: "pid"))
defimpl(Rediscl.Typeable, for: Port, do: def(typeof(_), do: "port"))
defimpl(Rediscl.Typeable, for: Reference, do: def(typeof(_), do: "reference"))
defimpl(Rediscl.Typeable, for: Tuple, do: def(typeof(_), do: "tuple"))
defimpl(Rediscl.Typeable, for: NaiveDateTime, do: def(typeof(_), do: "naivedatime"))
