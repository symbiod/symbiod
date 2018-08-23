# frozen_string_literal: true

module Onboarding
  # Find users where invited status to slack - false
  class UsersNotInvitedToGithubQuery
    def self.call
      User
        .joins(:developer_onboarding)
        .where(developer_onboardings: { github: false })
    end
  end
end
