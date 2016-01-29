class GoalStatusesController < ApplicationController

  def index
    render json: GoalStatus.all
  end

end
