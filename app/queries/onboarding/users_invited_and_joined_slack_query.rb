# frozen_string_literal: true

module Onboarding
  # Find users where invited and joined status to Slack
  class UsersInvitedAndJoinedSlackQuery
    def self.call
      User
        .joins(:developer_onboarding)
        .where(developer_onboardings: { slack_status: %w[slack_invited slack_joined] })
    end
  end
end
