# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class DashboardPolicy < ApplicationPolicy
  def allowed?
    return false unless user
    user.active? || user.has_role?(:staff)
  end

  private

  def staff?
    user.has_role? :staff
  end

  def mentor?
    user.has_role? :mentor
  end

  def staff_or_mentor?
    staff? || mentor?
  end

  def screening_completed_and_staff_or_mentor?(developer)
    developer.screening_completed? && staff_or_mentor?
  end
end
