require 'net/http'

module Publishable
  extend ActiveSupport::Concern

  included do
    helper_method :pubsub_session
  end

  def pubsub_session
    return nil unless (team = find_team)
    "#{controller_name}-#{team.id}"
  end

  def publish!(message, id = nil)
    uri = URI("http://localhost:4000/publish")
    message = {
      message: message,
      id: id,
      refresh_url: url_for(controller: controller_name, action: "refresh")
    }
    result = Net::HTTP.post_form(uri, "sid" => pubsub_session,
                                      "msg" => ActiveSupport::JSON.encode(message))
    result.code == "200"
  end
end
