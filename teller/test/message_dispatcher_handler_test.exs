defmodule MessageDispatcherHandlerTest do
  use ExUnit.Case, async: false
  alias Teller.Cowboy.WebsocketTester

  @port 8011
  @url 'ws://127.0.0.1:#{@port}/web-socket'

  setup_all do
    Dynamo.Cowboy.run Teller.Dynamo, port: @port, verbose: false, dispatch: Teller.WebRoutes.dispatch
    :ok
  end

  teardown_all do
    Dynamo.Cowboy.shutdown Teller.Dynamo
    :ok
  end

  test "it registers after connecting and unregisters after closing" do
    assert Teller.Pubsub.register_list("tester-1") == []
    client = WebsocketTester.start_link('#{@url}?room_id=tester-1')
    :timer.sleep 50
    assert length(Teller.Pubsub.register_list("tester-1")) == 1
    WebsocketTester.close(client)
    :timer.sleep 50
    assert Teller.Pubsub.register_list("tester-1") == []
  end

  test "it dispatches pubsub messages to websocket clients" do
    client = WebsocketTester.start_link('#{@url}?room_id=tester-2')
    WebsocketTester.text_spy_on(client)
    assert { 200, _, "Sent" } = request :post, "/publish?room_id=tester-2&data=hello+there"
    WebsocketTester.wait_for_text &(assert &1 == "hello there")
    WebsocketTester.close(client)
  end

  defp request(verb, path) do
    { :ok, status, headers, client } =
      :hackney.request(verb, "http://127.0.0.1:#{@port}" <> path, [], "", [])
    { :ok, body, _ } = :hackney.body(client)
    { status, headers, body }
  end
end
