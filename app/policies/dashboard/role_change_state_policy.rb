# frozen_string_literal: true

module Dashboard
  # This class distributes rights to create notes
  class RoleChangeStatePolicy < DashboardPolicy
    def update?
      staff_or_mentor?
    end
  end
end
