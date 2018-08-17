# frozen_string_literal: true

module Users
  # Allows to find users, who should be notified about uncompleted screenting.
  class ScreeningUncompletedNotificationUsersQuery
    def call
      incompleted_users
    end

    private

    def incompleted_users
      User.joins(:roles)
          .where(roles: { type: 'Roles::Developer',
                          state: %i[pending
                                    profile_completed
                                    policy_accepted
                                    screening_completed] })
         .where('users.created_at > ?', 3.days.ago)
    end
  end
end
