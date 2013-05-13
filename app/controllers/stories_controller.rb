class StoriesController < ApplicationController
  def index
    @new_story = Story.new
    @stories = Story.all
  end

  def create
    @story = Story.new(story_params)
    if @story.save
      redirect_to stories_url, notice: "new story was created successfully."
    else
      render :new
    end
  end

  private

  def story_params
    params
      .require(:story)
      .permit(:description, :points, :tech_lead_id, :product_manager_id,
              :business_driver, :spec_link)
  end
end
