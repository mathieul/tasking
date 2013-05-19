class StoriesController < ApplicationController
  def index
    @new_story = Story.new
    @stories = Story.rank(:row_order)
    @velocity = VelocityService.new(12, @stories)
  end

  def create
    @story = Story.new(story_params)
    if @story.save
      redirect_to stories_url, notice: "New story was created."
    else
      index
      render "index"
    end
  end

  def update
    @story = Story.find(params.require(:id))
    if @story.update(story_params)
      redirect_to stories_url, notice: "Story ##{@story.id} was updated."
    else
      index
      render "index"
    end
  end

  def destroy
    @story = Story.find(params.require(:id))
    @story.destroy
    redirect_to stories_url, notice: "Story ##{@story.id} was deleted."
  end

  def update_velocity
    raise "velocity is #{params[:velocity]}"
  end

  private

  def story_params
    extracted = params
      .require(:story)
      .permit(:description, :points, :tech_lead_id, :product_manager_id,
              :business_driver, :spec_link, :row_order_position)
    extracted.delete(:row_order_position) if extracted[:row_order_position].blank?
    extracted
  end
end
