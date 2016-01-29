class Progress < ActiveRecord::Base

  self.table_name = 'progress'

  belongs_to :goal

  def self.get(goal_id, user_id)
    where(goal_id: goal_id, user_id: user_id)
  end

end
