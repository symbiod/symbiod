# frozen_string_literal: true

module Onboarding
  # Find users where invited status to slack - false
  class UsersNotInvitedToSlackQuery
    def self.call
      User
        .joins(:developer_onboarding)
        .where(developer_onboardings: { slack_completed: false })
    end
  end
end
