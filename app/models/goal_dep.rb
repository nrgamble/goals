class GoalDep < ActiveRecord::Base

  belongs_to :goal
  belongs_to :dep, class_name: 'Goal'

end
