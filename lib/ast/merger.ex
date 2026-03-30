defmodule AshMembership.AST.Merger do
  def merge_module({:defmodule, meta, [name, [do: block]]}) do
    new_block =
      quote do
        unquote(block)

        def extensions do
          [AshMembership.Dsl.Extension]
        end

        policies do
          policy always() do
            check(AshMembership.Policy.Check)
          end
        end
      end

    {:defmodule, meta, [name, [do: new_block]]}
  end

  def merge_module(ast), do: ast
end
