# frozen_string_literal: true

# Allows only staff to manage newcomers applications
class TestTaskAssignmentPolicy < DashboardPolicy
  def index?
    staff_or_mentor?
  end

  def show?
    current_user_assignment?
  end

  def activate?
    current_user_assignment?
  end

  def reject?
    current_user_assignment?
  end

  def review?
    current_user_assignment?
  end

  # Defines a scope of Users, who can be available for acting person
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

  private

  def current_user_assignment?
    staff_assignment? || mentor_assignment?
  end

  def staff_assignment?
    staff? && record.screening_completed?
  end

  def mentor_assignment?
    mentor? && user.primary_skill == record.primary_skill && record.screening_completed?
  end
end
