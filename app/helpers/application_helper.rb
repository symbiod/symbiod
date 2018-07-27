module ApplicationHelper
  def count_of_pending_users
    "(#{User.screening_completed.count})" if User.screening_completed.any?
  end
end
