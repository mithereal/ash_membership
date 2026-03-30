defmodule AshMembership.Providers.ABAC do
  @behaviour AshMembership.Membership

  alias AshMembership.ABAC.{Compiler, Optimizer}
  alias AshMembership.Dsl.Reader

  @cache :ash_membership_abac_cache

  @impl true

  def allowed?(actor, resource, action, _context) do
    rules =
      Reader.rules_for(resource, action)
      |> resolve_actor_values(actor)

    rules
    |> Optimizer.optimize()
    |> Enum.all?(fn rule ->
      fun = get_compiled(rule)
      fun.(actor, resource)
    end)
  end

  @impl true
  def rules_for(resource, action),
    do: Reader.rules_for(resource, action)

  @impl true
  def compile_rule(rule), do: Compiler.compile(rule)

  @impl true
  def optimize_rules(rules), do: Optimizer.optimize(rules)

  @impl true
  def suggest_indexes(_), do: []

  @impl true
  def add_tuple(_), do: :ok

  @impl true
  def tuple_exists?(_), do: false

  defp resolve_actor_values(rules, actor) do
    Enum.map(rules, fn rule ->
      Map.update(rule, :value, nil, fn
        "actor." <> key ->
          Map.get(actor, String.to_existing_atom(key))

        other ->
          other
      end)
    end)
  end

  defp get_compiled(rule) do
    ensure_cache()

    case :ets.lookup(@cache, rule) do
      [{^rule, fun}] ->
        fun

      [] ->
        fun = Compiler.compile(rule)
        :ets.insert(@cache, {rule, fun})
        fun
    end
  end

  defp ensure_cache do
    case :ets.whereis(@cache) do
      :undefined -> :ets.new(@cache, [:named_table, :public, :set])
      _ -> :ok
    end
  end

  def allowed?(_, _, _, _), do: true
end
