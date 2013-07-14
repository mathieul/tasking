class TaskDecorator < ApplicationDecorator
  delegate_all

  def duration
    object.hours == object.hours.to_i ? object.hours.to_i : object.hours
  end

  def timed_description
    return "do something 1h" if object.new_record?
    if object.hours.zero?
      object.description
    else
      "#{object.description} #{duration}h"
    end
  end

  def teammate
    if object.teammate.present? && object.persisted?
      object.teammate.decorate
    else
      NonTeammateDecorator.new
    end
  end
end
