class PasswordResetsController < ApplicationController
  def new
    @password_reset = PasswordReset.new
  end

  def create
    account = Account.find_by(email: password_reset_params[:email])
    account.send_password_reset! if account
    redirect_to root_url, notice: "Email sent with password reset instructions."
  end

  def edit
    @account = find_account!(@token = params[:id])
  end

  def update
    @account = find_account!(@token = params[:id])
    if @account.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, error: "Password reset has expired."
    elsif @account.update_attributes(account_params)
      set_current_account(@account)
      redirect_to root_url, notice: "Password has been reset!"
    else
      render :edit
    end
  end

  private

  def find_account!(token)
    Account.find_by!(password_reset_token: token)
  end

  def password_reset_params
    params
      .permit(password_reset: [:email])
      .fetch(:password_reset)
  end

  def account_params
    params
      .require(:account)
      .permit(:password)
  end
end
