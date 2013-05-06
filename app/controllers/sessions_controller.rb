class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params[:session])
    account = Account.find_by_email(@session.email)
    if account && account.authenticate(@session.password)
      session[:account_id] = account.id
      redirect_to root_url, notice: "Welcome back!"
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end

  private

  def session_params
    params.permit(session: [:email, :password])
  end
end
