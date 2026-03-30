defmodule AshMembership.RuleLoader do
  alias AshMembership.Rule
  alias AshMembership.Repo

  @table :ash_membership_rules

  def load_all do
    ensure_table()

    Repo.all(Rule)
    |> Enum.group_by(&{&1.resource, &1.action})
    |> Enum.each(fn {key, rules} ->
      :ets.insert(@table, {key, rules})
    end)
  end

  def load_for(resource, action) do
    ensure_table()

    case :ets.lookup(@table, {resource, action}) do
      [{_, rules}] -> rules
      [] -> []
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
