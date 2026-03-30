defmodule AshMembership.Policy.Check do
  use Ash.Policy.Check

  @impl true
  def describe(_opts), do: "ABAC policy check"

  @impl true
  def match?(actor, resource, opts, context) do
    action = context.action.name

    AshMembership.Checker.allowed?(actor, resource, action)
  end
end
