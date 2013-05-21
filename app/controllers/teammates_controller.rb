class TeammatesController < ApplicationController
  before_action :authorize_and_find_team
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
      index
      render "index"
    end
  end

  def update
    if @teammate.update(teammate_params)
      redirect_to teammates_url, notice: "Teammate ##{@teammate.id} was updated."
    else
      index
      render "index"
    end
  end

  def destroy
    @teammate.destroy
    redirect_to teammates_url, notice: "Teammate ##{@teammate.id} was deleted."
  end

  private

  def teammate_params
    params
      .require(:teammate)
      .permit(:name, {:roles => []}, :account_id)
      .tap { |p| p[:roles].reject!(&:blank?) }
  end

  def find_teammate
    @teammate = @team.teammates.find(params.require(:id))
  end
end
