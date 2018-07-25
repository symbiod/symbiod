module ApplicationHelper
  def count_of_users_pending
    User.pending_users.count
  end
end
