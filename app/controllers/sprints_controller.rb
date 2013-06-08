class SprintsController < ApplicationController
  before_action :authorize
  before_action :find_team

  def new
    @stories = @team.stories.where(id: story_ids_params).decorate
    @sprint = Sprint.new(
      projected_velocity: @team.projected_velocity,
      start_on: tomorrow,
      end_on: tomorrow + @team.sprint_duration,
      story_ids: @stories.map(&:id)
    )
  end

  def create
    @sprint = @team.sprints.build(sprint_params)
    if @sprint.save
      redirect_to [:edit, @sprint]
    else
      new
      render :new
    end
  end

  def edit
    if (sprint = @team.sprints.find_from_kind_or_id(sprint_id))
      @task_table = TaskTable.new(sprint)
      @sprint = sprint.decorate
      @teammates = @team.teammates.with_role("teammate")
      @new_task = Task.new
      @kinds = %w[todo in_progress done]
    else
      sprint_label = sprint_id.to_i == 0 ? "#{sprint_id} sprint" : "sprint ##{sprint_id}"
      redirect_to stories_path, error: "There is no #{sprint_label}."
    end
  end

  private

  def sprint_id
    @sprint_id ||= params.require(:id)
  end

  def story_ids_params
    params
      .require(:sprint)
      .require(:story_ids)
  end

  def sprint_params
    secured = params
      .require(:sprint)
      .permit(:start_on, :end_on, :story_ids, story_ids: [])
      .merge(projected_velocity: @team.projected_velocity)
    secured[:story_ids] ||= []
    if secured[:story_ids].is_a?(String)
      secured[:story_ids] = secured[:story_ids].split(",")
    end
    secured[:story_ids].reject!(&:blank?)
    secured
  end

  def tomorrow
    @tomorrow ||= 1.day.from_now.to_date
  end
end
