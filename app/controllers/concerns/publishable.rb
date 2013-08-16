require 'net/http'

module Publishable
  extend ActiveSupport::Concern

  included do
    include ActionView::RecordIdentifier
    helper_method :pubsub_room_id
  end

  def pubsub_room_id
    team = find_team
    team ? "#{controller_name}-#{team.id}" : nil
  end

  def register_to_pubsub!
    @config = {
      room_id: pubsub_room_id,
      sid: current_sid,
      websocket_url: CONFIG[:websocket_url]
    }
  end

  def publish!(message, object = nil)
    uri = URI(CONFIG[:publish_url])
    data = {
      from: current_sid,
      message: message,
      refresh_url: url_for(controller: controller_name, action: "refresh")
    }
    data[:dom_id] = dom_id(object) if object
    result = Net::HTTP.post_form(uri, "room_id" => pubsub_room_id,
                                      "data" => ActiveSupport::JSON.encode(data))
    result.code == "200"
  end
end
