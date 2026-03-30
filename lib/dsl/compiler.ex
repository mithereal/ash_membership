defmodule AshMembership.Dsl.Compiler do
  @moduledoc """
  Converts ABAC DSL into Ash policy checks.
  """

  def compile(resource) do
    resource
    |> Ash.Resource.Info.extensions()
    |> Enum.flat_map(&extract/1)
  end

  defp extract(%{policies: %{abac: abac_blocks}}) do
    Enum.map(abac_blocks, fn block ->
      conditions = Enum.map(block.conditions, &normalize_condition/1)

      %{
        conditions: conditions
      }
    end)
  end

  defp extract(_), do: []

  defp normalize_condition(%{field: field, op: op, value: value}) do
    %{
      field: field,
      op: op,
      value: value
    }
  end
end
