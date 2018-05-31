# frozen_string_literal: true

# Allow only staff manage test task
class TestTaskPolicy < DashboardPolicy
  def index?
    staff? || mentor?
  end

  def new?
    mentor?
  end

  def create?
    mentor?
  end

  def edit?
    staff? || mentor?
  end

  def update?
    staff? || mentor?
  end

  def destroy?
    mentor?
  end
end
