defmodule AshMembership.Dsl.Reader do
  @moduledoc """
  Reads membership rules from an Ash resource DSL.
  """

  def rules_for(resource, action) do
    resource
    |> Ash.Resource.Info.extensions()
    |> Enum.find_value([], fn ext ->
      extract(ext, action)
    end)
  end

  defp extract(%{membership: %{checks: checks}}, action) do
    checks
    |> Enum.filter(fn check -> check.action == action end)
    |> Enum.flat_map(fn check ->
      check.conditions
    end)
  end

  defp extract(_, _), do: []
end
