defmodule AshMembership.PubSub do
  @moduledoc """
  PubSub integration for membership updates.
  """

  def broadcast(topic, message) do
    Phoenix.PubSub.broadcast(AshMembership.PubSub, topic, message)
  end

  def subscribe(topic) do
    Phoenix.PubSub.subscribe(AshMembership.PubSub, topic)
  end
end
