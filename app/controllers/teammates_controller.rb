class TeammatesController < ApplicationController
  def index
    @teammates = Teammate.all
    @new_teammate = Teammate.new
  end

  def create
    @teammate = Teammate.new(teammate_params)
    if @teammate.save
      redirect_to teammates_url, notice: "New teammate was created."
    else
      binding.pry
      index
      render "index"
    end
  end

  def update
    @teammate = Teammate.find(params.require(:id))
    if @teammate.update(teammate_params)
      redirect_to teammates_url, notice: "Teammate ##{@teammate.id} was updated."
    else
      index
      render "index"
    end
  end

  def destroy
    @teammate = Teammate.find(params.require(:id))
    @teammate.destroy
    redirect_to teammates_url, notice: "Teammate ##{@teammate.id} was deleted."
  end

  private

  def teammate_params
    params
      .require(:teammate)
      .permit(:name, {:roles => []}, :account_id)
  end
end
