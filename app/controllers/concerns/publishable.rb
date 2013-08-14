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
    result = Net::HTTP.post_form(uri, "sid" => pubsub_session,
                                      "msg" => message,
                                      "id"  => id)
    result.code == "200"
  end
end
