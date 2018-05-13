# frozen_string_literal: true

# Allow only stuff manage test task
class TestTaskPolicy < DashboardPolicy
  def index?
    stuff?
  end
  def edit?
    stuff?
  end

  def update?
    stuff?
  end
end
