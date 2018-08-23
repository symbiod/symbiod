# frozen_string_literal: true

module Developer
  class Onboarding
    # This job check invite to GitHub in asyncronous manner.
    class CheckInviteToGithubJob < ApplicationJob
      queue_as :default

      def perform
        users = ::Onboarding::UsersNotInvitedToGithubQuery.call
        users.each { |user| ::Ops::Developer::Onboarding::CheckInviteToGithub.call(user: user) }
      end
    end
  end
end
