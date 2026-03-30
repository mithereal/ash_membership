defmodule AshMembership.Dsl.Policy do
  use Spark.Dsl

  defmacro abac(do: block) do
    quote do
      check(AshMembership.Policy.ABACCheck, unquote(block))
    end
  end
end
