# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class DashboardPolicy < ApplicationPolicy
  def allowed?
    # Using safe operator, because user can be nil here
    # it he is not authenticated
<<<<<<< HEAD
    user&.active? || user&.has_role?(:staff)
=======
    result = user&.active? || user&.has_role?(:stuff)
    return false if result.nil?
    result
  end

  private

  def stuff?
    user.has_role? :stuff
>>>>>>> 443de4f8672fb506073a32e024d845fcd49f3890
  end
end
