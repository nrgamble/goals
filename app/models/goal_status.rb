class GoalStatus < ActiveRecord::Base

  belongs_to :goal, inverse_of: :goal_statuses

  before_save :check_completed
  after_save :check_enfants

  # Si record is new, return progress from previous goals
  # Sinon return current value
  def progress
    if self.new_record?
      progress = 0
      goal.deps.each do |dep|
        dep = dep.status(user_id)
        progress += dep.value if dep.completed
      end
    else
      progress = value
    end

    progress
  end

  private

    # before_save: Always update completed at the last minute
    def check_completed
      completed = ( value >= goal.value )
    end

    # after_save: If now completed, check to see if any child goals now have all dependencies met
    def check_enfants
      if completed
        goal.enfants.each do |g|
          g.check_autocomplete(user_id)
        end
      end
    end

end
