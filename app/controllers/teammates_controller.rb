class TeammatesController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_teammate, only: [:update, :destroy]

  def index
    @new_teammate = Teammate.new
    @teammates = @team.teammates
  end

  def create
    @teammate = @team.teammates.build(teammate_params)
    if @teammate.save
      redirect_to teammates_url, notice: "New teammate was created."
    else
      render_index_action
    end
  end

  def update
    if @teammate.update(teammate_params)
      redirect_to teammates_url, notice: "Teammate ##{@teammate.id} was updated."
    else
      render_index_action
    end
  end

  def destroy
    @teammate.destroy
    redirect_to teammates_url, notice: "Teammate ##{@teammate.id} was deleted."
  end

  private

  def render_index_action
    @team.teammates.reload
    index
    render "index"
  end

  def teammate_params
    secured = params
      .require(:teammate)
      .permit(:name, :account_id, :roles, roles: [])
    secured[:roles] ||= []
    secured[:roles] = secured[:roles].split(",") if secured[:roles].is_a?(String)
    secured[:roles].reject!(&:blank?)
    secured
  end

  def find_teammate
    @teammate = @team.teammates.find(params.require(:id))
  end
end
