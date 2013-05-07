module Authenticatable
  extend ActiveSupport::Concern

  included do
    helper_method :current_account
  end

  def current_account
    @current_account ||= Account.find_by!(auth_token: cookies[:auth_token]) if cookies[:auth_token]
  rescue ActiveRecord::RecordNotFound
    clear_current_account
    nil
  end

  def set_current_account(account, permanent: false)
    if permanent
      cookies.permanent[:auth_token] = account.auth_token
    else
      cookies[:auth_token] = account.auth_token
    end
  end

  def clear_current_account
    cookies.delete(:auth_token)
  end

  def authorize
    return if current_account
    redirect_to sign_in_url, alert: "You're not authorized to access this page"
  end
end
