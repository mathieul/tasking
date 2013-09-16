defmodule ApplicationRouterTest do
  use Teller.TestCase
  use Dynamo.HTTP.Case

  @endpoint ApplicationRouter

  test "it returns 406 Not Acceptable if room_id and data are not set" do
    conn = post("/publish")
    assert conn.status == 406
    assert conn.resp_body == "Not Acceptable"
  end

  test "it publishes the data to the room with /publish" do
    Teller.Pubsub.register("approuter-1", self)
    conn = post("/publish?room_id=approuter-1&data=my+message")
    assert conn.status == 200
    assert conn.resp_body == "Sent"
    receive do
      { :pubsub_message, message } -> assert message == "my message"
    after 50 -> raise "Did not receive message published"
    end
  end
end
