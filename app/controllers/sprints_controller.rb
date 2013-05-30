class SprintsController < ApplicationController
  before_action :authorize
  before_action :find_team

  def new
    tomorrow = 1.day.from_now.to_date
    @sprint = Sprint.new(
      projected_velocity: @team.projected_velocity,
      start_on: tomorrow,
      end_on: tomorrow + @team.sprint_duration
    )
    @stories = @team.stories.where(id: story_ids_params)
  end

  private

  def story_ids_params
    params.require(:story_ids)
  end
end
