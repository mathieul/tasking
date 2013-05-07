module Authenticatable
  extend ActiveSupport::Concern

  included do
    helper_method :current_account
  end

  def current_account
    @current_account ||= Account.find(session[:account_id]) if session[:account_id]
  rescue ActiveRecord::RecordNotFound
    reset_session
    nil
  end

  def set_current_account(account)
    session[:account_id] = account.id
  end

  def authorize
    return if current_account
    redirect_to sign_in_url, alert: "You're not authorized to access this page"
  end
end
