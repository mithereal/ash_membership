defmodule AshMembership.Compiler do
  def compile(rule) do
    fn actor, _resource, _context ->
      Enum.all?(rule.conditions || %{}, fn {k, v} ->
        Map.get(actor, String.to_existing_atom(k)) == v
      end)
    end
  end
end
