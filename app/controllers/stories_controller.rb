class StoriesController < ApplicationController
  def index
    @new_story = Story.new
    @stories = Story.all
  end
end
