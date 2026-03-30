defmodule AshMembership.Membership do
  @moduledoc """
  Behaviour for membership/authorization providers.

  This defines the contract used by:
  - DSL integrations
  - ABAC evaluation
  - Ash policies
  - Role + tuple systems
  """

  @type actor :: any()
  @type resource :: any()
  @type action :: atom()
  @type context :: map()

  @doc """
  Determines if an actor is allowed to perform an action on a resource.
  """
  @callback allowed?(actor(), resource(), action(), context()) :: boolean()

  @doc """
  Returns rules for a given resource and action.
  """
  @callback rules_for(resource(), action()) :: list()

  @doc """
  Compiles a rule into an executable function.
  """
  @callback compile_rule(rule :: map()) :: (actor(), resource() -> boolean())

  @doc """
  Optimizes a list of rules (removes redundancies, simplifies logic).
  """
  @callback optimize_rules(rules :: list()) :: list()

  @doc """
  Suggests database indexes based on rules/conditions.
  """
  @callback suggest_indexes(rules :: list()) :: list()

  @doc """
  Adds a relationship tuple (Zanzibar-style).
  """
  @callback add_tuple(tuple :: {atom(), atom(), atom()}) :: :ok | {:error, term()}

  @doc """
  Checks if a tuple relationship exists.
  """
  @callback tuple_exists?(tuple :: {atom(), atom(), atom()}) :: boolean()
end
