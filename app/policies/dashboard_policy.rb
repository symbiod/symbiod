# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class DashboardPolicy < ApplicationPolicy
  def index?
    return false unless user
    user.roles.any?(&:active?)
  end

  private

  def member?
    user&.has_role?(:member) && user&.role(:member)&.active?
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
    staff? || member? || mentor?
  end

  def not_member?
    staff? || mentor? || author?
  end

  def staff_or_author_record?
    staff_or_mentor? || record.author == user
  end
end
