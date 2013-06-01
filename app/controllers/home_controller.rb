class HomeController < ApplicationController
  before_action :authorize

  def redirect
    redirect_to stories_url
  end
end
