class HomeController < ApplicationController
  before_action :authorize, only: :edit

  def index
  end

  def edit
  end
end
