# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class DashboardPolicy < ApplicationPolicy
  def allowed?
    return false unless user
    user.active? || user.has_role?(:staff)
  end

  private

  def developer?
    user.has_role? :developer
  end

  def staff?
    user.has_role? :staff
  end

  def mentor?
    user.has_role? :mentor
  end

  def author?
    user.has_role? :author
  end

  def staff_or_mentor?
    staff? || mentor?
  end

  def not_author?
    staff? || developer? || mentor?
  end

  def not_developer?
    staff? || mentor? || author?
  end
end
