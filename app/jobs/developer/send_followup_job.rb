# frozen_string_literal: true

require './app/operations/ops/developer/send_screening_followup'

module Developer
  class SendFollowupJob < ApplicationJob
    # Select users with status
    # "pending, profile_completed, policy_accepted,
    # screening_completed"
    # and runs mailer for users who have this status

    queue_as :default

    def perform
      @users = Users::ScreeningUncompletedUsersQuery.new.call
      @users.each do |user|
        Ops::Developer::SendScreeningFollowup.call(user: user)
      end
    end
  end
end
