class TasksController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_taskable_story
  before_action :find_task, only: [:update, :destroy, :progress, :complete]

  def create
    @task = @taskable_story.tasks.build(task_params.merge(team: @team))
    @task.save!
    respond_with_fresh_task_table
  end

  def update
    @task.update!(task_params)
    respond_with_fresh_task_table
  end

  def destroy
    @task = @taskable_story.tasks.find(params.require(:id))
    @task.destroy
    respond_with_fresh_task_table
  end

  def progress
    @task.progress!
    respond_with_fresh_task_table
  end

  def complete
    @task.complete!
    respond_with_fresh_task_table
  end

  private

  def find_taskable_story
    @taskable_story = TaskableStory
      .find(params.require(:taskable_story_id))
  end

  def find_task
    @task = @taskable_story.tasks.find(params.require(:id))
  end

  def task_params
    params
      .require(:task)
      .permit(:row_order_position, :timed_description, :description,
              :hours, :status, :teammate_id)
  end

  def refresh_task_table
    @task_table = TaskTable.new(@taskable_story.sprint)
    render :refresh_task_table
  end

  def respond_with_fresh_task_table
    respond_to do |format|
      format.html { redirect_to [:edit, @taskable_story.sprint] }
      format.js   { refresh_task_table }
    end
  end
end
