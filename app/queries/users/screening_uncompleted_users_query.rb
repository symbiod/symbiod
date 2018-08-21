# frozen_string_literal: true

module Users
  # Allows to find users, who should be notified about uncompleted screenting.
  class ScreeningUncompletedUsersQuery
    def call
      uncompleted_users
    end

    private

    def uncompleted_users
      User.joins(:roles)
          .where(roles: { type: 'Roles::Developer',
                          state: %i[pending
                                    profile_completed
                                    policy_accepted] })
          .where('users.last_screening_followup_date > ?', 3.days.ago)
    end
  end
end
