# frozen_string_literal: true

# Allow only staff manage test task
class TestTaskPolicy < DashboardPolicy
  def index?
    staff_or_mentor?
  end

  alias new? index?
  alias create? index?
  alias edit? index?
  alias update? index?
  alias activate? index?
  alias deactivate? index?
end
