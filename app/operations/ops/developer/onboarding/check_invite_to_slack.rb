# frozen_string_literal: true

module Ops
  module Developer
    class Onboarding
      # Here check members by organization GitHub
      class CheckInviteToSlack < ::Ops::Developer::BaseOperation
        step :check_membership!
        success :set_onboarding_to_github!

        private

        def check_membership!(_ctx, user:, **)
          SlackService.new(ENV['SLACK_TOKEN']).member_team?(user.email)
        end

        def set_onboarding_to_github!(_ctx, user:, **)
          user.developer_onboarding.update!(slack_completed: true)
        end
      end
    end
  end
end
