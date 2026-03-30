defmodule AshMembership.ABAC.Compiler do
  def compile(rule) do
    fn actor, resource ->
      eval(rule, actor, resource)
    end
  end

  defp eval(%{field: field, op: :eq, value: value}, actor, resource) do
    get(field, actor, resource) == resolve(value, actor)
  end

  defp eval(%{field: field, op: :lt, value: value}, actor, resource) do
    get(field, actor, resource) < resolve(value, actor)
  end

  defp eval(%{field: field, op: :gt, value: value}, actor, resource) do
    get(field, actor, resource) > resolve(value, actor)
  end

  defp eval(%{and: conditions}, actor, resource) do
    Enum.all?(conditions, &eval(&1, actor, resource))
  end

  defp eval(%{or: conditions}, actor, resource) do
    Enum.any?(conditions, &eval(&1, actor, resource))
  end

  defp get("actor." <> key, actor, _resource),
    do: Map.get(actor, String.to_existing_atom(key))

  defp get("resource." <> key, _actor, resource),
    do: Map.get(resource, String.to_existing_atom(key))

  defp resolve("actor." <> key, actor),
    do: Map.get(actor, String.to_existing_atom(key))

  defp resolve(val, _), do: val
end
