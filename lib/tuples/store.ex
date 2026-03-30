defmodule AshMembership.Tuples.Store do
  @table :ash_membership_tuples

  def init do
    :ets.new(@table, [:named_table, :public, :set])
  end

  def add({subject, relation, object}) do
    :ets.insert(@table, {subject, relation, object})
  end

  def check?(subject, relation, object) do
    :ets.member(@table, {subject, relation, object})
  end

  def delete(tuple) do
    :ets.delete_object(@table, tuple)
  end
end
