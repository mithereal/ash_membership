defmodule AshMembership.Dsl.Resource do
  defmacro __using__(_opts) do
    quote do
      extension(AshMembership.Dsl.Extension)

      def __ash_membership_rules__(action) do
        AshMembership.Dsl.Reader.rules_for(__MODULE__, action)
      end
    end
  end
end
