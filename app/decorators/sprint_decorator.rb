class SprintDecorator < Draper::Decorator
  delegate_all

  def label
    "##{object.id}"
  end

  def start_date
    object.start_on.to_s(:long)
  end

  def end_date
    object.end_on.to_s(:long)
  end
end
