class HomeController < ApplicationController
  def redirect
    redirect_to current_account.present? ? stories_url : sign_in_url
  end
end
