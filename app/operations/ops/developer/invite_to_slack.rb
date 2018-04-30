# frozen_string_literal: true

module Ops
  module Developer
    # Handles all business logic regarding adding new member to GitHub.
    # Besides calling public API, it also markes onboarding step as completed.
    class InviteToSlack < BaseOperation
      step :add_to_slack!
      success :mark_step_as_complete!

      def add_to_slack!(_ctx, user:, **)
        # TODO: where can we get a name of user at this step?
        SlackService.new(ENV['SLACK_TOKEN']).invite(user.email, '', '')
        true
      rescue SlackIntegration::FailedApiCallException => e
        return true if e.message == 'Unsuccessful invite api call: {"ok"=>false, "error"=>"already_invited"}'
      end

      def mark_step_as_complete!(_ctx, user:, **)
        user.developer_onboarding.update!(slack: true)
      end
    end
  end
end
