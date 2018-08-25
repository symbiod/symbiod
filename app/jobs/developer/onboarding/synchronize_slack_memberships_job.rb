# frozen_string_literal: true

module Developer
  class Onboarding
    # This job check invite to Slack in asyncronous manner.
    class SynchronizeSlackMembershipsJob < ApplicationJob
      queue_as :default

      def perform
        users = ::Onboarding::UsersInvitedAndJoinedSlackQuery.call
        users.each { |user| ::Ops::Developer::Onboarding::SynchronizeSlackMembership.call(user: user) }
      end
    end
  end
end
