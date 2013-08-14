class ApplicationController < ActionController::Base
  include Authenticatable
  include Publishable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :error

  protected

  def find_team
    @team ||= Team.find(current_account.team) if current_account.present?
  end
end
