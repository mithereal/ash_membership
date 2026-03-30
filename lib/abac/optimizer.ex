defmodule AshMembership.ABAC.Optimizer do
  @moduledoc """
  Removes redundant or invalid rules.
  """

  def optimize(conditions) do
    conditions
    |> Enum.uniq()
    |> Enum.reject(&invalid?/1)
  end

  defp invalid?(%{value: nil}), do: true
  defp invalid?(_), do: false
end
