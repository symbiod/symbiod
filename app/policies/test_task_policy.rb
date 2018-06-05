# frozen_string_literal: true

# Allow only staff manage test task
class TestTaskPolicy < DashboardPolicy
  def index?
    staff_or_mentor?
  end

  def new?
    staff_or_mentor?
  end

  def create?
    staff_or_mentor?
  end

  def edit?
    staff_or_mentor?
  end

  def update?
    staff_or_mentor?
  end

  def destroy?
    staff_or_mentor?
  end
end
