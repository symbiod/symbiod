# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class TestTaskAssignmentPolicy < DashboardPolicy
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
end
