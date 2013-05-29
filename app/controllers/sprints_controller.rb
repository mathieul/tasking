class SprintsController < ApplicationController
  before_action :authorize
  before_action :find_team

  def new
    @sprint = Sprint.new
  end
end
