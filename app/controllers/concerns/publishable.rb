require 'net/http'

module Publishable
  extend ActiveSupport::Concern

  included do
    helper_method :pubsub_room_id
  end

  def pubsub_room_id
    team = find_team
    team ? "#{controller_name}-#{team.id}" : nil
  end

  def publish!(message, object = nil)
    uri = URI("http://localhost:4000/publish")
    data = {
      from: current_account.try(:email),
      message: message,
      refresh_url: url_for(controller: controller_name, action: "refresh")
    }
    data[:dom_id] = dom_id(object) if object
    result = Net::HTTP.post_form(uri, "room_id" => pubsub_room_id,
                                      "data" => ActiveSupport::JSON.encode(data))
    result.code == "200"
  end
end
