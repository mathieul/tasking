class SessionsController < ApplicationController
  def new
    @session = Session.new(remember_me: session[:remember_me])
  end

  def create
    @session = Session.new(session_params)
    session[:remember_me] = @session.remember_me
    account = Account.find_by_email(@session.email)
    if account && account.authenticate(@session.password)
      set_current_account(account, permanent: @session.remember_me)
      redirect_to root_url, notice: "Welcome back!"
    else
      flash.now.alert = "Email or password is invalid"
      render :new
    end
  end

  def destroy
    clear_current_account
    redirect_to root_url, notice: "Logged out successfully"
  end

  private

  def session_params
    params
      .permit(session: [:email, :password, :remember_me])
      .fetch(:session)
  end
end
