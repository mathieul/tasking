class MessagesController < ApplicationController
  include ActionController::Live

  def events
    response.headers["Content-Type"] = "text/event-stream"
    4.times do |n|
      response.stream.write "data: #{n}...\n\n"
      sleep 1
    end
  rescue IOError
    logger.info "Stream closed"
  ensure
    response.stream.close
  end
end
