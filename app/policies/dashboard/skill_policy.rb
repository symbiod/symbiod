# frozen_string_literal: true

module Dashboard
  # Policy manage skill, access only staff and mentor
  class SkillPolicy < DashboardPolicy
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

    def activate?
      staff_or_mentor?
    end

    def deactivate?
      staff_or_mentor?
    end
  end
end
