class Goal < ActiveRecord::Base

  # The events and their values accumulated for this goal
  has_many :progress, class_name: 'Progress', inverse_of: :goal
  
  # The goals which need to be completed for this goal to be available
  has_many :goal_deps
  has_many :deps, through: :goal_deps, source: :dep

  # The goals which rely on this goal being completed
  has_many :deps_goal, class_name: 'GoalDep', foreign_key: 'dep_id'
  has_many :enfants, through: :deps_goal, source: :goal

  # The current status of the goal
  has_many :goal_statuses, inverse_of: :goal

  # Are all dependencies for this goal met?
  def deps_completed?(user_id)
    completed = true
    self.deps.each do |dep|
      completed = false unless dep.status(user_id).completed
    end
    completed
  end

  # Find the status of a goal for a user
  def status(user_id)
    goal_status = self.goal_statuses.where(user_id: user_id).first
    if goal_status.nil?
      goal_status = GoalStatus.new(goal_id: self.id, user_id: user_id)
      goal_status.value = goal_status.progress
    end
    goal_status
  end

  # GoalStatus:before_save, autocomplete this goal if dependency completion is only requirement
  def check_autocomplete(user_id)
    return self if not deps_completed?(user_id)

    goal_status = self.status(user_id)
    goal_status.save if goal_status.is_completed?
    return self
  end

  # Find all goals available to a user
  def self.all_available(user_id)
    _goals = []
    goals  = Goal.all - self.all_completed(user_id)
    goals.each do |goal|
      _goals << goal if goal.deps_completed?(user_id)
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
