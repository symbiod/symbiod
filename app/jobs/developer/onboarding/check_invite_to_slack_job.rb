# frozen_string_literal: true

module Developer
  class Onboarding
    # This job check invite to Slack in asyncronous manner.
    class CheckInviteToSlackJob < ApplicationJob
      queue_as :default

      def perform
        users = ::Onboarding::UsersNotInvitedToSlackQuery.call
        users.each { |user| ::Ops::Developer::Onboarding::CheckInviteToSlack.call(user: user) }
      end
    end
  end
end
