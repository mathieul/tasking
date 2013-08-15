class StoriesController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_story, only: [:edit, :update, :update_position, :destroy]

  def index
    setup_to_render_main
    register_to_pubsub!
  end

  def new
    @story = Story.new(row_order_position: params[:row_order_position])
    setup_to_render_main
    register_to_pubsub!
  end

  def create
    @story = @team.stories.build(story_params)
    respond_to do |format|
      if @story.save
        publish!("create:success", @story)
        notice = "New story was created."
        format.html { redirect_to stories_url, notice: notice }
        format.js   { setup_to_render_main; flash.now[:notice] = notice }
      else
        format.html { setup_to_render_main; render :new }
        format.js   { render :create_error }
      end
    end
  end

  def edit
    setup_to_render_main
    register_to_pubsub!
  end

  def update
    respond_to do |format|
      if @story.update(story_params)
        publish!("update:success", @story)
        format.html { redirect_to stories_url }
        format.js   { setup_to_render_main }
      else
        format.html { setup_to_render_main; render :edit }
        format.js   { render :update_error }
      end
    end
  end

  def update_position
    @story.update(row_order_position: params.require(:position))
    publish!("update_position:success", @story)
    respond_to do |format|
      format.html { redirect_to stories_url }
      format.js   { setup_to_render_main; render :update }
    end
  end

  def destroy
    @story.destroy
    warning = "Story ##{@story.id} was deleted."
    publish!("destroy", @story)
    respond_to do |format|
      format.html { redirect_to stories_url, warning: warning }
      format.js   { setup_to_render_main; flash.now[:warning] = warning }
    end
  end

  def update_velocity
    @team.update(projected_velocity: params.require(:velocity))
    publish!("update_velocity")
    respond_to do |format|
      format.html { redirect_to stories_url }
      format.js   { setup_to_render_main }
    end
  end

  def refresh
    setup_to_render_main
    render layout: false
  end

  private

  def setup_to_render_main
    @stories = @team.stories.ranked.backlogged.decorate
    @velocity = VelocityService.new(@team.projected_velocity, @stories)
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
