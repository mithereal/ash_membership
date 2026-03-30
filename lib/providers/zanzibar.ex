defmodule AshMembership.Providers.Zanzibar do
  @behaviour AshMembership.Membership

  @table :ash_membership_tuples

  @impl true
  def allowed?(actor, resource, action, _context) do
    ensure_table()

    tuple = {actor, action, resource}
    tuple_exists?(tuple)
  end

  @impl true
  def rules_for(_resource, _action), do: []

  @impl true
  def compile_rule(_rule), do: fn _, _ -> true end

  @impl true
  def optimize_rules(rules), do: rules

  @impl true
  def suggest_indexes(_), do: []

  @impl true
  def add_tuple(tuple) do
    ensure_table()
    :ets.insert(@table, {tuple, true})
    :ok
  end

  @impl true
  def tuple_exists?(tuple) do
    ensure_table()

    case :ets.lookup(@table, tuple) do
      [{^tuple, true}] -> true
      _ -> false
    end
  end

  defp ensure_table do
    case :ets.whereis(@table) do
      :undefined ->
        :ets.new(@table, [:named_table, :public, :set])

      _ ->
        :ok
    end
  end
end
