defmodule AshMembership.Checker do
  @moduledoc """
  Central dispatcher for membership logic.

  Delegates to the configured provider.
  """

  @behaviour AshMembership.Membership

  @provider Application.compile_env(
              :ash_membership,
              :provider,
              AshMembership.Providers.Default
            )

  def allowed?(actor, resource, action, context \\ %{}) do
    Engine.allowed?(actor, resource, action, context)
  end

  # Public API (delegated)
  def allowed?(actor, resource, action, context, :provider) do
    @provider.allowed?(actor, resource, action, context)
  end

  def rules_for(resource, action) do
    @provider.rules_for(resource, action)
  end

  def compile_rule(rule) do
    @provider.compile_rule(rule)
  end

  def optimize_rules(rules) do
    @provider.optimize_rules(rules)
  end

  def suggest_indexes(rules) do
    @provider.suggest_indexes(rules)
  end

  def add_tuple(tuple) do
    @provider.add_tuple(tuple)
  end

  def tuple_exists?(tuple) do
    @provider.tuple_exists?(tuple)
  end
end
