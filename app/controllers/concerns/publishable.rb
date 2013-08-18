require 'net/http'

module Publishable
  extend ActiveSupport::Concern

  def pubsub_room_id(name)
    team = find_team
    team ? "#{name}-#{team.id}" : nil
  end

  def register_to_pubsub!(name = controller_name)
    @config = {
      room_id: pubsub_room_id(name),
      sid: current_sid,
      websocket_url: CONFIG[:websocket_url]
    }
  end

  def publish!(message, content = {})
    object = content.delete(:object)
    room = content.delete(:room) || controller_name
    uri = URI(CONFIG[:publish_url])
    data = {
      from: current_sid,
      message: message,
      refresh_url: refresh_url_for(content)
    }
    data[:dom_id] = dom_id(object) if object
    result = Net::HTTP.post_form(uri, "room_id" => pubsub_room_id(room),
                                      "data" => ActiveSupport::JSON.encode(data))
    result.code == "200"
  end

  private

  def refresh_url_for(url_info)
    definition = {controller: controller_name, action: "refresh"}.merge(url_info)
    url_for(definition)
  end
end
