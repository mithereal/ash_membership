defmodule AshMembership.Engine do
  alias AshMembership.{RuleLoader, CompiledCache, Compiler}

  def allowed?(actor, resource, action, context) do
    RuleLoader.load_for(resource, action)
    |> Enum.all?(fn rule ->
      key = {:rule_fn, rule.id}

      fnc =
        case CompiledCache.get(key) do
          nil ->
            compiled = Compiler.compile(rule)
            CompiledCache.put(key, compiled)
            compiled

          cached ->
            cached
        end

      fnc.(actor, resource, context)
    end)
  end
end
