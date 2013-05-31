class SprintsController < ApplicationController
  before_action :authorize
  before_action :find_team

  def new
    @sprint = Sprint.new(
      projected_velocity: @team.projected_velocity,
      start_on: tomorrow,
      end_on: tomorrow + @team.sprint_duration
    )
    @stories = @team.stories.where(id: story_ids_params).decorate
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
    render text: "TODO"
  end

  private

  def story_ids_params
    params.require(:story_ids)
  end

  def sprint_params
    params
      .require(:sprint)
      .permit(:start_on, :end_on, story_ids: [])
      .merge(projected_velocity: @team.projected_velocity)
  end

  def tomorrow
    @tomorrow ||= 1.day.from_now.to_date
  end
end
