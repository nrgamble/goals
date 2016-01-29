class RenameGoalStatusProgressToValue < ActiveRecord::Migration
  def change
    rename_column :goal_statuses, :progress, :value
  end
end
