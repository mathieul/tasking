class TeammatesController < ApplicationController
  def index
    @teammates = Teammate.all
  end
end
