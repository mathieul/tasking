class ApplicationController < ActionController::Base
  include Authenticatable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :error

  protected

  def authorize_and_find_team
    authorize
    @team = Team.find(current_account.team)
  end
end
