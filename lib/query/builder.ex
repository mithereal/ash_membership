defmodule AshMembership.Query.Builder do
  @moduledoc """
  Builds secure queries using ABAC + actor context.
  """

  alias AshMembership.ABAC.EctoCompiler

  def build(query, actor, conditions) do
    EctoCompiler.compile(query, conditions, actor)
  end
end
