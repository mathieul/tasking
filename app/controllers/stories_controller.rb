class StoriesController < ApplicationController
  include Effectable

  before_action :authorize
  before_action :find_team
  before_action :find_story, only: [:edit, :update, :update_position, :destroy]

  def index
    setup_to_render_main
  end

  def new
    @story = Story.new(row_order_position: params[:row_order_position])
    setup_to_render_main
  end

  def create
    @story = @team.stories.build(story_params)
    respond_to do |format|
      if @story.save
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
  end

  def update
    respond_to do |format|
      if @story.update(story_params)
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
    respond_to do |format|
      format.html { redirect_to stories_url }
      format.js   { setup_to_render_main; render :update }
    end
  end

  def destroy
    @story.destroy
    warning = "Story ##{@story.id} was deleted."
    respond_to do |format|
      format.html { redirect_to stories_url, warning: warning }
      format.js   { setup_to_render_main; flash.now[:warning] = warning }
    end
  end

  def update_velocity
    @team.update(projected_velocity: params.require(:velocity))
    respond_to do |format|
      format.html { redirect_to stories_url }
      format.js   { setup_to_render_main }
    end
  end

  private

  def setup_to_render_main
    @stories = @team.stories.ranked.backlogged.decorate
    @velocity = VelocityService.new(@team.projected_velocity, @stories)
  end

  def render_refresh_main(options = {})
    url = options.delete(:url) || stories_url
    setup_to_render_main
    render template: "shared/refresh_main", locals: {
      content: {partial: "stories/stories", stories: @stories, velocity: @velocity},
      updated_id: options[:updated] && dom_id(options[:updated]),
      flash: options_to_flash(options),
      redirect_url: url
    }
  end

  def options_to_flash(options)
    supported_types = %i[info notice warning error]
    if (type = options.keys.first { |type| type.in?(supported_types) })
      message = options.delete(type)
      options.merge(type: type == :notice ? :success : type, message: message)
    else
      {}
    end
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
