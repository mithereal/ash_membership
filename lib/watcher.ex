defmodule AshMembership.Watcher do
  use GenServer

  alias AshMembership.CompiledCache

  def start_link(_), do: GenServer.start_link(__MODULE__, %{})

  def init(state) do
    AshMembership.Reload.subscribe()
    {:ok, state}
  end

  def handle_info(:reload, state) do
    CompiledCache.clear()
    {:noreply, state}
  end
end
