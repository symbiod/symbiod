# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class DashboardPolicy < ApplicationPolicy
  def allowed?
    return false unless user
    user.roles.any?(&:active?)
  end

  private

  def developer?
    user&.has_role?(:developer) && user&.role(:developer)&.active?
  end

  def staff?
    user&.has_role?(:staff) && user&.role(:staff)&.active?
  end

  def mentor?
    user&.has_role?(:mentor) && user&.role(:mentor)&.active?
  end

  def author?
    user&.has_role?(:author) && user&.role(:author)&.active?
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

  def staff_or_author_record?
    staff_or_mentor? || record.author == user
  end
end
