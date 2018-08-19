# frozen_string_literal: true

module Developer
  module Screening
    class SendFollowupJob < ApplicationJob
      # Select users with status
      # "pending, profile_completed, policy_accepted,
      # screening_completed"
      # and runs mailer for users who have this status

      queue_as :default

      def perform
        @users = Users::ScreeningUncompletedUsersQuery.new.call
        @users.each do |user|
          Ops::Developer::Screening::SendScreeningFollowup.call(user: user)
        end
      end
    end
  end
end
