module ApplicationHelper
  def count_of_pending_users
    pending_applications = Role.where(state: :screening_completed).count
    "(#{pending_applications})" unless pending_applications.zero?
  end
end
