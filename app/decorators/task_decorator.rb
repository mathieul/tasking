class TaskDecorator < ApplicationDecorator
  delegate_all

  def duration
    object.hours == object.hours.to_i ? object.hours.to_i : object.hours
  end

  def timed_description
    if object.hours.zero?
      object.description
    else
      "#{object.description} #{duration}h"
    end
  end
end
