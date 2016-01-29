class ProgressController < ApplicationController

  def index
    progress = Progress.get(params[:goal_id], params[:user_id])
    render json: progress
    # render json: progress[0].goal.status(params[:user_id])
  end

  def create
    progress = Progress.new(progress_params)

    # TODO: this should be a before_save
    status   = progress.goal.status(progress_params[:user_id])
    if status.new?
      # status = GoalStatus.new(progress_params)
      status.goal_id   = progress_params[:goal_id]
      status.user_id   = progress_params[:user_id]
      status.value     = progress_params[:value]
      status.completed = false
    else
      status.value = status.value.to_i + progress.value.to_i
    end

    # TODO: this should be an after_save
    if !status.completed and progress.save 
      # TODO: this breaks my idea for HORSE
      status.completed = true if status.value.to_i >= status.goal.value.to_i
      status.save
    end

    render json: status
  end

private

  def progress_params
    params.require(:progress).permit(:goal_id, :user_id, :value)
  end

end
