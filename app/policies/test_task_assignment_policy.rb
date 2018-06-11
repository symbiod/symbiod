# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class TestTaskAssignmentPolicy < DashboardPolicy
  def index?
    staff_or_mentor?
  end

  def show?
    staff_or_mentor?
  end

  def activate?
    staff_or_mentor?
  end

  def reject?
    staff_or_mentor?
  end

  def review?(developer)
    screening_completed_and_staff_or_mentor?(developer)
  end

  class Scope < Scope
    def resolve
      if user.has_role? :staff
        User.screening_completed.all
      elsif user.has_role? :mentor
        ReviewableApplicantsQuery.new(user).call
      else
        []
      end
    end
  end
end
