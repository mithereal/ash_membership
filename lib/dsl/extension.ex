defmodule AshMembership.Dsl.Extension do
  use Ash.Dsl.Extension

  # Define the DSL section
  sections do
    section :sections do
      describe "Custom authorization sections"
      # you can add nested entities here later
    end
  end
end