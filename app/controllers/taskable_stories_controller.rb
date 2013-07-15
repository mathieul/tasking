class TaskableStoriesController < ApplicationController
  before_action :authorize
  before_action :find_team

  def update
    @taskable_story = TaskableStory.where(team_id: @team.id).find(params.require(:id))
    @taskable_story.update(taskable_story_params)
    respond_to do |format|
      format.html { redirect_to [:edit, @taskable_story.sprint] }
      format.js   { @task_table = TaskTable.new(@taskable_story.sprint) }
    end
  end

  private

  def taskable_story_params
    params
      .require(:taskable_story)
      .permit(:description, :owner_id)
  end
end
