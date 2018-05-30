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
end
