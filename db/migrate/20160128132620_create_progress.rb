class CreateProgress < ActiveRecord::Migration
  def change
    create_table :progress do |t|
      t.integer :goal_id
      t.string :user_id
      t.integer :value

      t.timestamps null: false
    end
  end
end
