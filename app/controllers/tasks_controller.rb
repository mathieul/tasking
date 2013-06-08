class TasksController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_taskable_story

  def create
    task = @taskable_story.tasks.build(task_params.merge(team: @team))
    task.save!
    redirect_to [:edit, @taskable_story.sprint]
  end

  def update
    task = @taskable_story.tasks.find(params.require(:id))
    task.update!(task_params)
    redirect_to [:edit, @taskable_story.sprint]
  end

  def destroy
    task = @taskable_story.tasks.find(params.require(:id))
    task.destroy
    redirect_to [:edit, @taskable_story.sprint]
  end

  private

  def find_taskable_story
    @taskable_story = TaskableStory
      .find(params.require(:taskable_story_id))
  end

  def task_params
    params
      .require(:task)
      .permit(:row_order_position, :description, :hours, :status, :teammate_id)
  end
end