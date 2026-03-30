defmodule AshMembership.Providers.Hybrid do
  @behaviour AshMembership.Membership

  alias AshMembership.Providers.{ABAC, Zanzibar}

  @impl true
  def allowed?(actor, resource, action, context, :basic) do
    abac_allowed? = ABAC.allowed?(actor, resource, action, context)
    tuple_allowed? = Zanzibar.allowed?(actor, resource, action, context)

    abac_allowed? or tuple_allowed?
  end

  @impl true
  def rules_for(resource, action),
    do: ABAC.rules_for(resource, action)

  @impl true
  def compile_rule(rule),
    do: ABAC.compile_rule(rule)

  @impl true
  def optimize_rules(rules),
    do: ABAC.optimize_rules(rules)

  @impl true
  def suggest_indexes(rules),
    do: ABAC.suggest_indexes(rules)

  @impl true
  def add_tuple(tuple),
    do: Zanzibar.add_tuple(tuple)

  def allowed?(actor, resource, action, context) do
    AshMembership.Checker.allowed?(actor, resource, action, context)
  end

  @impl true
  def tuple_exists?(tuple),
    do: Zanzibar.tuple_exists?(tuple)
end
