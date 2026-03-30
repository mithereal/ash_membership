defmodule AshMembership do
  use Ash.Resource

  def extensions do
    [AshMembership.Dsl.Extension]
  end

  def provider do
    Application.get_env(:ash_membership, :provider)
  end
end
