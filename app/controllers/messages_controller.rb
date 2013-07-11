class MessagesController < ApplicationController
  include ActionController::Live

  def events
    response.headers["Content-Type"] = "text/event-stream"
    redis = Redis.new(url: $redis_url)
    redis.psubscribe("messages.*") do |on|
      on.psubscribe do |event, total|
        logger.info "MessagesController#events: psubscribe #{event}/#{total}"
        response.stream.write("event: #{event}\n")
        response.stream.write("total: #{total}\n\n")
      end
      on.pmessage do |pattern, event, data|
        logger.info "MessagesController#events: pmessage #{event}/#{data}"
        response.stream.write("event: #{event}\n")
        response.stream.write("data: #{data}\n\n")
      end
    end
  rescue IOError
    logger.info "Stream closed"
  ensure
    redis.quit
    response.stream.close
  end
end
