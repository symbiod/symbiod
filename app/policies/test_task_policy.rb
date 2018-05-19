# frozen_string_literal: true

# Allow only staff manage test task
class TestTaskPolicy < DashboardPolicy
  def index?
    staff?
  end

  def edit?
    staff?
  end

  def update?
    staff?
  end
end
