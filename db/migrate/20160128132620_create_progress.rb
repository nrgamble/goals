class CreateProgress < ActiveRecord::Migration
  def change
    create_table :progress do |t|
      t.integer :goal_id
      t.string :user_id
      t.string :value

      t.timestamps null: false
    end
  end
end
