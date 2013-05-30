module Effectable
  extend ActiveSupport::Concern

  included do
    helper_method :effects
  end

  def effects
    @effects ||= session.delete(:effects) || {}
  end

  def trigger_effect!(highlight: nil)
    effects = session[:effects] ||= {}
    (effects[:highlight] ||= []) << dom_id_for(highlight) if highlight.present?
  end

  private

  def dom_id_for(object)
    return object unless object.respond_to?(:to_key)
    ActionView::RecordIdentifier.dom_id(object)
  end
end
