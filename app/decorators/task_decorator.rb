class TaskDecorator < ApplicationDecorator
  delegate_all

  def timed_description
    binding.pry if object.description == "do something 1h"
    [object.description, object.hours.zero? ? nil : "#{object.hours}h"].join(" ")
  end
end
