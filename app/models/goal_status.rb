class GoalStatus < ActiveRecord::Base

  belongs_to :goal, inverse_of: :goal_statuses

  before_save :check_completed
  after_save :check_enfants

  def is_completed?
    self.value >= self.goal.value
  end

  # Si record is new, return progress from previous goals
  # Sinon return current value
  def progress
    if self.new_record?
      progress = 0
      self.goal.deps.each do |dep|
        dep = dep.status(user_id)
        progress += dep.value if dep.completed
      end
    else
      progress = self.value
    end

    progress
  end

  private

    # before_save: Always update completed at the last minute
    def check_completed
      self.completed = self.is_completed?
    end

    # after_save: If completed, check to see if any child goals now have all dependencies met
    def check_enfants
      if self.completed
        self.goal.enfants.each do |e|
          e.check_autocomplete(self.user_id)
        end
      end
    end

end
