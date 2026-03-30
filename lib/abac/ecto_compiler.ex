defmodule AshMembership.ABAC.EctoCompiler do
  import Ecto.Query

  def compile(query, conditions, actor) do
    Enum.reduce(conditions, query, fn condition, query ->
      apply_condition(query, condition, actor)
    end)
  end

  defp apply_condition(query, %{field: field, op: :eq, value: value}, actor) do
    where(query, [r], field(r, ^to_atom(field)) == ^resolve(value, actor))
  end

  defp apply_condition(query, %{field: field, op: :lt, value: value}, actor) do
    where(query, [r], field(r, ^to_atom(field)) < ^resolve(value, actor))
  end

  defp apply_condition(query, %{field: field, op: :gt, value: value}, actor) do
    where(query, [r], field(r, ^to_atom(field)) > ^resolve(value, actor))
  end

  defp apply_condition(query, %{and: conditions}, actor) do
    Enum.reduce(conditions, query, fn cond, q ->
      apply_condition(q, cond, actor)
    end)
  end

  defp apply_condition(query, %{or: conditions}, actor) do
    dynamic =
      Enum.reduce(conditions, false, fn cond, acc ->
        dynamic([r], ^acc or ^build_dynamic(cond, actor))
      end)

    where(query, ^dynamic)
  end

  defp build_dynamic(%{field: field, op: :eq, value: value}, actor) do
    dynamic([r], field(r, ^to_atom(field)) == ^resolve(value, actor))
  end

  defp resolve("actor." <> key, actor),
    do: Map.get(actor, String.to_existing_atom(key))

  defp resolve(val, _), do: val

  defp to_atom("resource." <> key), do: String.to_atom(key)
end
