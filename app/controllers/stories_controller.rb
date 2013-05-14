class StoriesController < ApplicationController
  def index
    @new_story = Story.new
    @stories = Story.all
  end

  def create
    @story = Story.new(story_params)
    if @story.save
      redirect_to stories_url, notice: "New story was created."
    else
      redirect_to stories_url, error: "Could not create new story (TODO: handle error)"
    end
  end

  def update
    @story = Story.find(params.require(:id))
    if @story.update(story_params)
      redirect_to stories_url, notice: "Story ##{@story.id} was updated."
    else
      redirect_to stories_url, error: "Could update story ##{@story.id} (TODO: handle error)"
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
