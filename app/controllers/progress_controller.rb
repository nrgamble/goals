class ProgressController < ApplicationController

  def index
    progress = Progress.get(params[:goal_id], params[:user_id])
    render json: progress
  end

  def create
    progress = Progress.new(progress_params)
    progress.save
    render json: progress
  end

  # matchups_ref
  def event
    progress = Progress.new({ user_id: progress_params[:user_id], value: progress_params[:value] })

    goals = []
    Goal.all_available(progress_params[:user_id]).each do |goal|
      if goal.event == progress_params[:event]
        goal.progress << progress
        goals << goal.status(progress_params[:user_id])
      end
    end

    render json: goals
  end

private

  def progress_params
    params.require(:progress).permit(:goal_id, :event, :user_id, :value)
  end

end
