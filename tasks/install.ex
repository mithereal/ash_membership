defmodule Mix.Tasks.AshMembership.Install do
  use Mix.Task

  def run(_) do
    Mix.shell().info("Installing AshMembership...")

    File.mkdir_p!("lib/ash_membership")

    Mix.shell().info("Done. Wire Repo + PubSub manually if needed.")
  end
end