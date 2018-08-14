# frozen_string_literal: true

module Users
  # Allows to find users, who should be notified about new applicant.
  # We should notify all staff members.
  # Additionally we notify mentors, who has the same specialization, as user.
  class ScreeningUncompletedNotificationUsersQuery
    def call
      incompleted_users
    end

    private

    def incompleted_users
      User
        .joins(:roles)
        .where(roles: { type: 'Roles::Developer',
                        state: %i[pending
                                  profile_completed
                                  policy_accepted
                                  screening_completed] } )
    end
  end
end
