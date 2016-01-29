class Goal < ActiveRecord::Base

  has_many :progress, class_name: 'Progress'
  has_many :goal_deps
  has_many :deps, through: :goal_deps, source: :dep
  has_many :goal_statuses

  # Find the status of a goal for a user
  def status(user_id)
    gs = goal_statuses.where(user_id: user_id)
    gs.empty? ? GoalStatus.new : gs.first
  end

  # Find all goals available to a user
  def self.all_available(user_id)
    _goals = []
    goals  = Goal.all - all_completed(user_id)

    # Validate all dependencies are met
    goals.each do |goal|
      good = true
      goal.deps.each do |dep|
        good = false if !dep.status(user_id).completed
      end
      _goals << goal if good
    end
    _goals
  end

  # Find all goes with progress for a user
  def self.all_in_progress(user_id)
    Goal.joins(:goal_statuses).where(goal_statuses: { user_id: user_id, completed: false })
  end

  # Find all goals completed by a user
  def self.all_completed(user_id)
    Goal.joins(:goal_statuses).where(goal_statuses: { user_id: user_id, completed: true })
  end

end
