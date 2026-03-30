defmodule AshMembership.Policy.ABACCheck do
  use Ash.Policy.Check

  @impl true
  def describe(_), do: "ABAC DSL policy"

  @impl true
  def match?(actor, resource, opts, context) do
    action = context.action.name

    rules =
      AshMembership.Dsl.Compiler.compile(resource)
      |> Enum.filter(&action_matches?(&1, action))

    Enum.all?(rules, fn rule ->
      fun = AshMembership.ABAC.Compiler.compile(rule)
      fun.(actor, resource)
    end)
  end

  defp action_matches?(_rule, _action), do: true
end
