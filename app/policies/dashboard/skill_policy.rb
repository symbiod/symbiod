# frozen_string_literal: true

module Dashboard
  # Policy manage skill, access only staff and mentor
  class SkillPolicy < DashboardPolicy
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
end
