defmodule AshMembership.Rule do
  use Ecto.Schema

  schema "membership_rules" do
    field(:resource, :string)
    field(:action, :string)
    field(:conditions, :map)
    field(:priority, :integer, default: 0)

    timestamps()
  end
end
