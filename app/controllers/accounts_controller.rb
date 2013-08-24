class AccountsController < ApplicationController
  before_action :find_account, only: [:edit, :update]
  before_action :authorize, only: [:edit, :update]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params.merge(admin: true))
    if @account.save
      set_current_account(@account)
      EmailService.new(account: :activate).deliver(id: @account.id)
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      render :new
    end
  end

  def activate
    case account = Account.find_by(activation_token: activation_token_params)
    when account.nil?
      redirect_to root_url, error: "Invalid activation token."
    when account.activated?
      redirect_to root_url, error: "Account is already activated."
    else
      account.activate!
      set_current_account(account, permanent: true)
      flash[:warning] = "Your account is now activated, please select your password."
      redirect_to [:edit, account]
    end
  end

  def edit
    authorize! :read, @account
  end

  def update
    authorize! :update, @account
    if @account.update(account_params)
      redirect_to root_url, notice: "Your account was updated."
    else
      render :edit
    end
  end

  private

  def account_params
    params.require(:account).permit(:email, :password, team_attributes: [:name])
  end

  def activation_token_params
    params.require(:token)
  end

  def find_account
    @account = Account.find(params.require(:id))
  end
end
