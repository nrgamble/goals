class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :ref
      t.string :name
      t.string :description
      t.string :value
      t.string :event

      t.timestamps null: false
    end
  end
end
