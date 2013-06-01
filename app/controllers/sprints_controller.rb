class SprintsController < ApplicationController
  before_action :authorize
  before_action :find_team

  def new
    @stories = @team.stories.where(id: story_ids_params).decorate
    @sprint = Sprint.new(
      projected_velocity: @team.projected_velocity,
      start_on: tomorrow,
      end_on: tomorrow + @team.sprint_duration,
      stories: @stories
    )
  end

  def create
    @sprint = @team.sprints.build(sprint_params)
    if @sprint.save
      redirect_to [:edit, @sprint]
    else
      new
      render "new"
    end
  end

  def edit
    @sprint = @team.sprints.find_from_label_or_id(params.require[:id])
  end

  private

  def story_ids_params
    params.require(:story_ids)
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
