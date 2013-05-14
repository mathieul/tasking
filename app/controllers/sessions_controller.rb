class SessionsController < ApplicationController
  def new
    @session = Session.new(remember_me: session[:remember_me])
  end

  def create
    @session = Session.new(session_params)
    session[:remember_me] = @session.remember_me
    account, status = authenticate_and_verify_account(@session.email, @session.password)
    case status
    when :activated
      set_current_account(account, permanent: @session.remember_me)
      redirect_to root_url, notice: "Welcome back!"
    when :not_activated
      flash.now.alert = "This account hasn't yet been confirmed. Please follow instructions emailed."
      render :new
    else
      flash.now[:error] = "Email or password is invalid."
      render :new
    end
  end

  def destroy
    clear_current_account
    redirect_to root_url, notice: "Logged out successfully."
  end

  private

  def session_params
    params
      .permit(session: [:email, :password, :remember_me])
      .fetch(:session)
  end

  def authenticate_and_verify_account(email, password)
    account = Account.find_by_email(email)
    return [nil, :invalid] unless account && account.authenticate(password)
    [account, account.activated? ? :activated : :not_activated]
  end
end
