# frozen_string_literal: true

<<<<<<< HEAD
# Allows only staff to manage newcomers applications
class TestTaskAssignmentPolicy < ApplicationPolicy
=======
# Allows only staff to manage newcomers applications
class TestTaskAssignmentPolicy < DashboardPolicy
>>>>>>> 443de4f8672fb506073a32e024d845fcd49f3890
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
<<<<<<< HEAD

  private

  def staff?
    user.has_role? :staff
  end
=======
>>>>>>> 443de4f8672fb506073a32e024d845fcd49f3890
end
