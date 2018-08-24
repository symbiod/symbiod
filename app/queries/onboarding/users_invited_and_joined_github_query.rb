# frozen_string_literal: true

module Onboarding
  # Find users where invited and joined status to GitHub
  class UsersInvitedAndJoinedGithubQuery
    def self.call
      User
        .joins(:developer_onboarding)
        .where(developer_onboardings: { github_status: %w[github_invited github_joined] })
    end
  end
end
