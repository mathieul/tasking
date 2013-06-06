class TasksController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_sprint

  def create
  end

  def update
  end

  def destroy
  end

  private

  def find_sprint
    @sprint = @team.sprints.find(params.require(:sprint_id))
  end
end