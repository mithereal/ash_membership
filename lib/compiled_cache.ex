defmodule AshMembership.CompiledCache do
  @table :ash_membership_cache

  def init do
    :ets.new(@table, [:named_table, :public, :set])
  end

  def get(key) do
    case :ets.lookup(@table, key) do
      [{^key, value}] -> value
      [] -> nil
    end
  end

  def put(key, value) do
    :ets.insert(@table, {key, value})
  end

  def clear do
    :ets.delete_all_objects(@table)
  end
end
