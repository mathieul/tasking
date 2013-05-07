class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params[:session])
    account = Account.find_by_email(@session.email)
    if account && account.authenticate(@session.password)
      set_current_account(account)
      redirect_to root_url, notice: "Welcome back!"
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Logged out successfully"
  end

  private

  def session_params
    params.permit(session: [:email, :password])
  end
end
