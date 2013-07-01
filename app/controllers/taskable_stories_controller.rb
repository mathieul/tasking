class TaskableStoriesController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_taskable_story

  def update
    @taskable_story.update(taskable_story_params)
    redirect_to [:edit, @taskable_story.sprint]
  end

  private

  def taskable_story_params
    params
      .require(:taskable_story)
      .permit(:description, :owner_id)
  end

  def find_taskable_story
    @taskable_story = TaskableStory.where(team_id: @team.id).find(params.require(:id))
  end
end
