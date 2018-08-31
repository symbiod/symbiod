# frozen_string_literal: true

module Screening
  # Select users with status
  # "pending, profile_completed, policy_accepted"
  # and runs mailer for users who have this status
  class SendFollowupJob < ApplicationJob
    queue_as :default

    def perform
      Ops::Screening::SendScreeningFollowup.call
    end
  end
end
