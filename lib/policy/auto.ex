defmodule AshMembership.Policy.Auto do
  defmacro __using__(_opts) do
    quote do
      use Ash.Policy

      policies do
        policy always() do
          check(AshMembership.Policy.Check)
        end
      end
    end
  end
end
