# frozen_string_literal: true

module Roles
  module Screening
    # Allows to find users, who should be notified about uncompleted screenting.
    class UncompletedRolesQuery
      def call
        uncompleted_users
      end

      private

      def uncompleted_users
        Role.joins(:user)
            .where(roles: { type: 'Roles::Member',
                            state: %i[pending
                                      profile_completed
                                      policy_accepted] })
            .where('roles.last_screening_followup_date < ?', 3.days.ago)
      end
    end
  end
end
