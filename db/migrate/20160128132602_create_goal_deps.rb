class CreateGoalDeps < ActiveRecord::Migration
  def change
    create_table :goal_deps do |t|
      t.integer :goal_id
      t.integer :dep_id

      t.timestamps null: false
    end
  end
end
