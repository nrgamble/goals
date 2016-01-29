class GoalDepsController < ApplicationController

  def create
    goaldep = GoalDep.new(goaldep_params)
    goaldep.save
    render json: goaldep
  end

private

  def goaldep_params
    params.require(:goal_dep).permit(:goal_id, :dep_id)
  end

end
