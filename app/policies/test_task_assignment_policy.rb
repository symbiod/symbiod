# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class TestTaskAssignmentPolicy < ApplicationPolicy
  def index?
    staff?
  end

  def show?
    staff?
  end

  def activate?
    staff?
  end

  def reject?
    staff?
  end

  private

  def staff?
    user.has_role? :staff
  end
end
