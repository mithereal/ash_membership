defmodule AshMembership.Query.IndexAdvisor do
  @moduledoc """
  Suggests indexes based on ABAC conditions.
  """

  def suggest(conditions) do
    Enum.map(conditions, fn %{field: field} ->
      {:index, field}
    end)
  end
end
