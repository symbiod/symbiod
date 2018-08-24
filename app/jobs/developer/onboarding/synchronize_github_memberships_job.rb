# frozen_string_literal: true

module Developer
  class Onboarding
    # This job check invite to GitHub in asyncronous manner.
    class SynchronizeGithubMembershipsJob < ApplicationJob
      queue_as :default

      def perform
        users = ::Onboarding::UsersInvitedAndJoinedGithubQuery.call
        return if users.blank?
        users.each { |user| ::Ops::Developer::Onboarding::SynchronizeGithubMembership.call(user: user) }
      end
    end
  end
end
