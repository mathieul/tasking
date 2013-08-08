Code.require_file "test_helper.exs", __DIR__

defmodule PubsubTest do
  use ExUnit.Case
  alias Wspubsub.Pubsub

  teardown do
    Pubsub.unregister(self)
    :ok
  end

  test "it can return the list of registered pids" do
    Pubsub.register(self)
    assert Pubsub.register_list == [inspect self]
  end

  test "it receives message published when registered" do
    Pubsub.register(self)
    Pubsub.publish("Hello there" )
    receive do
      { :pubsub_message, message } -> assert message == "Hello there"
    after 50 -> raise "Did not receive message published"
    end
  end

  test "it doesn't receive messages after it has unregistered" do
    Pubsub.register(self)
    Pubsub.unregister(self)
    Pubsub.publish("Hello there")
    receive do
      message -> raise "Received unexpected message #{inspect message} while unregistered"
    after 100 -> assert "Nothing received"
    end
  end

  test "the server remembers the last 10 messages" do
    Enum.each 1..12, fn n -> Pubsub.publish("msg#{n}") end
    expected = Enum.map 12..3, fn n -> "msg#{n}" end
    assert Pubsub.last_messages == expected
  end
end
