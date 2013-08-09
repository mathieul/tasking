Code.require_file "test_helper.exs", __DIR__

defmodule PubsubTest do
  use ExUnit.Case
  alias Wspubsub.Pubsub

  test "it returns the list of session ids with #session_ids" do
    Pubsub.register(self, "abc123")
    assert Pubsub.session_ids == ["abc123"]
    Pubsub.unregister(self, "abc123")
  end

  test "it can return the list of registered pids of a session" do
    Pubsub.register(self, "ou812")
    assert Pubsub.register_list("ou812") == [inspect self]
    Pubsub.unregister(self, "ou812")
  end

  test "it receives message published when registered" do
    Pubsub.register(self, "ou812")
    Pubsub.publish("Hello there", "ou812")
    receive do
      { :pubsub_message, message } -> assert message == "Hello there"
    after 50 -> raise "Did not receive message published"
    end
    Pubsub.unregister(self, "ou812")
  end

  # test "it doesn't receive messages after it has unregistered" do
  #   Pubsub.register(self)
  #   Pubsub.unregister(self)
  #   Pubsub.publish("Hello there")
  #   receive do
  #     message -> raise "Received unexpected message #{inspect message} while unregistered"
  #   after 100 -> assert "Nothing received"
  #   end
  # end

  # test "the server remembers the last 10 messages" do
  #   Enum.each 1..12, fn n -> Pubsub.publish("msg#{n}") end
  #   expected = Enum.map 12..3, fn n -> "msg#{n}" end
  #   assert Pubsub.last_messages == expected
  # end
end
