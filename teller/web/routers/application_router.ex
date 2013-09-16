defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    conn.fetch([:params])
  end

  post "/publish" do
    [ room_id, data ] = Enum.map [ :room_id, :data ], &(conn.params[&1])
    if room_id && data do
      Teller.Pubsub.publish(room_id, data)
      conn.resp 200, "Sent"
    else
      conn.resp 406, "Not Acceptable"
    end
  end
end
