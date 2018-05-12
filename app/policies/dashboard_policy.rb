# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class DashboardPolicy < ApplicationPolicy
  def allowed?
    # Using safe operator, because user can be nil here
    # it he is not authenticated
    result = user&.active? || user&.has_role?(:staff)
    return false if result.nil?
    result
  end

  private

  def staff?
    user.has_role? :staff
  end
end
