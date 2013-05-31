class StoriesController < ApplicationController
  include Effectable

  before_action :authorize
  before_action :find_team
  before_action :find_story, only: [:update, :update_position, :destroy]

  def index
    @new_story = Story.new
    @stories = @team.stories.ranked.backlogged.decorate
    @velocity = VelocityService.new(@team.projected_velocity, @stories)
  end

  def create
    @story = @team.stories.build(story_params)
    if @story.save
      trigger_effect!(highlight: @story)
      redirect_to stories_url
    else
      render_index_action
    end
  end

  def update
    if @story.update(story_params)
      trigger_effect!(highlight: @story)
      redirect_to stories_url
    else
      render_index_action
    end
  end

  def update_position
    @story.update(row_order_position: params.require(:position))
    trigger_effect!(highlight: @story)
    redirect_to stories_url
  end

  def destroy
    @story.destroy
    redirect_to stories_url, notice: "Story #{@story.description.inspect} was deleted."
  end

  def update_velocity
    velocity = params.require(:velocity)
    @team.update(projected_velocity: velocity)
    trigger_effect!(highlight: "velocity")
    redirect_to stories_url
  end

  private

  def render_index_action
      index
      render "index"
  end

  def authorize_and_find_team
    authorize
    @team = Team.find(current_account.team)
  end

  def story_params
    extracted = params
      .require(:story)
      .permit(:description, :points, :tech_lead_id, :product_manager_id,
              :business_driver, :spec_link, :row_order_position)
    extracted.delete(:row_order_position) if extracted[:row_order_position].blank?
    extracted
  end

  def find_story
    @story = @team.stories.find(params.require(:id))
  end
end
