module Effectable
  extend ActiveSupport::Concern

  included do
    helper_method :classy_effects_for
  end

  def classy_effects_for(object)
    id = object.respond_to?(:id) ? object.id : object
    effects.each.with_object([]) do |(effect, target), classes|
      classes << "trigger-#{effect}" if target == id
    end.join(" ")
  end

  def effects
    @effects ||= session.delete(:effects) || {}
  end

  def trigger_effect!(highlight: nil)
    effects = (session[:effects] ||= {})
    if highlight.present?
      effects[:highlight] = highlight.respond_to?(:id) ? highlight.id : highlight
    end
  end
end
