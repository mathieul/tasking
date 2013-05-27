class StoriesController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_story, only: [:update, :update_position, :destroy]

  def index
    @new_story = Story.new
    @stories = @team.stories.rank(:row_order)
    @highlight_id = session.delete(:highlight_id) if session[:highlight_id].present?
    @velocity = VelocityService.new(@team.projected_velocity, @stories)
  end

  def create
    @story = @team.stories.build(story_params)
    if @story.save
      redirect_to stories_url, notice: "New story was created."
    else
      index
      render "index"
    end
  end

  def update
    if @story.update(story_params)
      redirect_to stories_url, notice: "Story ##{@story.id} was updated."
    else
      index
      render "index"
    end
  end

  def update_position
    @story.update(row_order_position: params.require(:position))
    session[:highlight_id] = @story.id
    redirect_to stories_url, notice: "Story ##{@story.id} was moved successfully."
  end

  def destroy
    @story.destroy
    redirect_to stories_url, notice: "Story ##{@story.id} was deleted."
  end

  def update_velocity
    velocity = params.require(:velocity)
    @team.update(projected_velocity: velocity)
    redirect_to stories_url, notice: "The team velocity is now #{velocity}."
  end

  private

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
