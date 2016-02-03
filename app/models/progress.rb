class Progress < ActiveRecord::Base

  self.table_name = 'progress'

  belongs_to :goal, inverse_of: :progress

  after_create :update_goal_status

  def self.get(goal_id, user_id)
    where(goal_id: goal_id, user_id: user_id)
  end

  protected

    # after_create
    # TODO: do the same after creating a delete progress
    def update_goal_status
      status = self.goal.status(self.user_id)
      status.value += self.value
      status.save
    end

end
