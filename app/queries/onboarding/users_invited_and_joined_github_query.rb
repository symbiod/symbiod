# frozen_string_literal: true

module Onboarding
  # Find users where invited and joined status to GitHub
  class UsersInvitedAndJoinedGithubQuery < BaseOnboardingQuery
    class << self
      private

      def query_condition
        { github_status: %w[github_invited github_joined] }
      end
    end
  end
end
