# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class TestTaskAssignmentPolicy < DashboardPolicy
  def index?
    staff? || mentor?
  end

  def show?
    staff? || mentor?
  end

  def activate?
    staff? || mentor?
  end

  def reject?
    staff? || mentor?
  end
end
