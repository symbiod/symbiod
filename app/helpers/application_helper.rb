module ApplicationHelper
  def count_of_pending_users
    if User.screening_completed.any?
      "(#{User.screening_completed.count})"
    end
  end
end
