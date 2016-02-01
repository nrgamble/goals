class CreateGoalStatuses < ActiveRecord::Migration
  def change
    create_table :goal_statuses do |t|
      t.integer :goal_id
      t.string :user_id
      t.integer :value
      t.boolean :completed

      t.timestamps null: false
    end
  end
end
