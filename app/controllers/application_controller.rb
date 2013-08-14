class ApplicationController < ActionController::Base
  include Authenticatable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :error
  helper_method :update_session

  def update_session
    return nil unless (team = find_team)
    [controller_name, action_name, team.id].join("-")
  end

  protected

  def find_team
    @team ||= Team.find(current_account.team) if current_account.present?
  end
end
