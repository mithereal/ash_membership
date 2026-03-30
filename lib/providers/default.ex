defmodule AshMembership.Providers.Default do
  @behaviour AshMembership.Membership

  alias AshMembership.ABAC.{Compiler, Optimizer}
  alias AshMembership.Dsl.Reader

  @cache :ash_membership_rules_cache

  @impl true
  def allowed?(actor, resource, action, _context) do
    rules =
      rules_for(resource, action)
      |> resolve_actor_values(actor)

    rules
    |> optimize_rules()
    |> Enum.all?(fn rule ->
      fun = get_compiled(rule)
      fun.(actor, resource)
    end)
  end

  @impl true
  def rules_for(resource, action) do
    Reader.rules_for(resource, action)
  end

  @impl true
  def compile_rule(rule), do: Compiler.compile(rule)

  @impl true
  def optimize_rules(rules), do: Optimizer.optimize(rules)

  @impl true
  def suggest_indexes(rules), do: []

  @impl true
  def add_tuple(_tuple), do: :ok

  @impl true
  def tuple_exists?(_tuple), do: false

  # --- internals ---

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
        fun = compile_rule(rule)
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
end
