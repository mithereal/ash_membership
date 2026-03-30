defmodule AshMembership.Reload do
  @topic "ash_membership:rules"

  def broadcast do
    Phoenix.PubSub.broadcast(:ash_membership_pubsub, @topic, :reload)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(:ash_membership_pubsub, @topic)
  end
end
