class GoalsController < ApplicationController

  def index
    if params[:user_id]
      goals = Goal.all_available(params[:user_id])
    else
      goals = Goal.all
    end

    render json: goals
  end

  def completed
    render json: Goal.all_completed(params[:user_id])
  end

  def show
    goal = Goal.find(params[:id])
    # if stale?(last_modified: goal.updated_at, public: true)
      render json: goal
      # render json: goal.progress
      # render json: goal.deps
    # end
  end

  def create
    goal = Goal.new(goal_params)
    goal.save
    render json: goal
  end

private

  def goal_params
    params.require(:goal).permit(:name, :ref, :value, :event)
  end

end
