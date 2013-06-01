class SprintDecorator < Draper::Decorator
  delegate_all

  def label
    "##{object.id}"
  end

  def start_on
    object.start_on.to_s(:long)
  end

  def end_on
    object.end_on.to_s(:long)
  end

  def status
    object.status ? object.status.humanize : ""
  end
end
