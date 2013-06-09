class TaskDecorator < ApplicationDecorator
  delegate_all

  def timed_description
    [object.description, object.hours.zero? ? nil : "#{object.hours}h"].compact.join(" ")
  end
end
