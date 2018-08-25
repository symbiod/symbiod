# frozen_string_literal: true

module Onboarding
  # Find users where invited and joined status to Slack
  class UsersInvitedAndJoinedSlackQuery < BaseOnboardingQuery
    class << self
      private

      def query_condition
        { slack_status: %w[slack_invited slack_joined] }
      end
    end
  end
end
