class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      set_current_account(@account)
      EmailService.new(account: :activate).deliver(id: @account.id)
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      render :new
    end
  end

  def activate
    account = Account.find_by(activation_token: activation_token_params)
    account.activate! if account
    redirect_to root_url, notice: "Thank you for confirming your account!"
  end

  private

  def account_params
    secured = params
      .require(:account)
      .permit(:email, :password, team_attributes: [:name])
    secured[:account][:password_confirmation] = secured[:account][:password]
    secured
  end

  def activation_token_params
    params.require(:token)
  end
end
