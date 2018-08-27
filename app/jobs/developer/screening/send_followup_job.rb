# frozen_string_literal: true
module Developer
  module Screening
    # Select users with status
    # "pending, profile_completed, policy_accepted"
    # and runs mailer for users who have this status
    class SendFollowupJob < ApplicationJob
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
