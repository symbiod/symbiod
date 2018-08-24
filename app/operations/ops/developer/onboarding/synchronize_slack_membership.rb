# frozen_string_literal: true

module Ops
  module Developer
    class Onboarding
      # Here check members by organization GitHub
      class SynchronizeSlackMembership < ::Ops::Developer::BaseOperation
        step :check_membership!
        failure :mark_step_as_left!
        success :mark_step_as_joined!

        private

        def check_membership!(_ctx, user:, **)
          SlackService.new(ENV['SLACK_TOKEN']).member_team?(user.email)
        end

        def mark_step_as_left!(_ctx, user:, **)
          user.developer_onboarding.slack_left! if user.developer_onboarding.slack_joined?
        end

        def mark_step_as_joined!(_ctx, user:, **)
          user.developer_onboarding.slack_join! if user.developer_onboarding.slack_invited?
        end
      end
    end
  end
end
