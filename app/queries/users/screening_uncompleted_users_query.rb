# frozen_string_literal: true

# TODO: rename to Roles
module Users
  # Allows to find users, who should be notified about uncompleted screenting.
  # TODO: rename
  class ScreeningUncompletedUsersQuery
    def call
      uncompleted_users
    end

    private

    def uncompleted_users
      # TODO: query roles
      #Role.joins(:users)
        #.where()
      User.joins(:roles)
          .where(roles: { type: 'Roles::Member',
                          state: %i[pending
                                    profile_completed
                                    policy_accepted] })
          .where('users.last_screening_followup_date > ?', 3.days.ago)
    end
  end
end
