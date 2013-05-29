module Effectable
  extend ActiveSupport::Concern

  included do
    helper_method :classy_effects_for
  end

  def classy_effects_for(object)
    summary = summarize_object(object)
    effects.each.with_object([]) do |(effect, target), classes|
      classes << "trigger-#{effect}" if target == summary
    end.join(" ")
  end

  def trigger_effect!(highlight: nil)
    effects = (session[:effects] ||= {})
    effects[:highlight] = summarize_object(highlight) if highlight.present?
  end

  private

  def effects
    @effects ||= session.delete(:effects) || {}
  end

  def summarize_object(object)
    object.respond_to?(:id) ? "#{object.class.to_s.underscore}-#{object.id}" : object
  end
end
