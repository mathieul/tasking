class TeammatesController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_teammate, only: [:edit, :update, :destroy]

  def index
    setup_to_render_main
  end

  def new
    @teammate = Teammate.new
    setup_to_render_main
  end

  def edit
    setup_to_render_main
  end

  def create
    @teammate = @team.teammates.build(teammate_params)
    if @teammate.save
      redirect_to teammates_url, notice: "New teammate was created."
    else
      setup_to_render_main(true)
      render :new
    end
  end

  def update
    if @teammate.update(teammate_params)
      redirect_to teammates_url, notice: "Teammate #{@teammate.name.inspect} was updated."
    else
      setup_to_render_main(true)
      render :edit
    end
  end

  def destroy
    @teammate.destroy
    redirect_to teammates_url, notice: "Teammate #{@teammate.name.inspect} was deleted."
  end

  private

  def setup_to_render_main(reload = false)
    @team.teammates.reload if reload
    @teammates = @team.teammates.decorate
  end

  def teammate_params
    secured = params
      .require(:teammate)
      .permit(:name, :account_id, :initials, :color, :roles, roles: [])
    secured[:roles] ||= []
    secured[:roles] = secured[:roles].split(",") if secured[:roles].is_a?(String)
    secured[:roles].reject!(&:blank?)
    secured
  end

  def find_teammate
    @teammate = @team.teammates.find(params.require(:id))
  end
end
