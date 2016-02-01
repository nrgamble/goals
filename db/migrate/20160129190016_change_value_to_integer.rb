class ChangeValueToInteger < ActiveRecord::Migration
  def change
    change_column :goals, :value, :integer
    change_column :progress, :value, :integer
    change_column :goal_statuses, :value, :integer
  end
end
