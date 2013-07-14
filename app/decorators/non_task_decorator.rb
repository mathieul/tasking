class NonTaskDecorator
  def teammate
    NonTeammateDecorator.new
  end

  def id
    nil
  end

  def description
    ""
  end

  def duration
    "&nbsp;".html_safe
  end

  def timed_description
    "do something 1h"
  end

  def persisted?
    false
  end
end
