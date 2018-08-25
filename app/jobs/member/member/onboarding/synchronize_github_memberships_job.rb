# frozen_string_literal: true

module Member
  class Onboarding
    # This job check invite to GitHub in asyncronous manner.
    class SynchronizeGithubMembershipsJob < ApplicationJob
      queue_as :default

      def perform
        users = ::Onboarding::UsersInvitedAndJoinedGithubQuery.call
        users.each { |user| ::Ops::Member::Onboarding::SynchronizeGithubMembership.call(user: user) }
      end
    end
  end
end
