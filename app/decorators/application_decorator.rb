class ApplicationDecorator < Draper::Decorator
  def updated_at
    helpers.time_tag(object.updated_at)
  end
end
