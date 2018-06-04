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
        SlackService.new(ENV['SLACK_TOKEN']).invite(user, channels(user))
        true
      rescue SlackIntegration::FailedApiCallException => e
        handle_exception(e)
      end

      def mark_step_as_complete!(_ctx, user:, **)
        user.developer_onboarding.update!(slack: true)
      end

      def handle_exception(exception)
        return true if exception.message == 'Unsuccessful invite api call: {"ok"=>false, "error"=>"already_invited"}'
        raise
      end

      def channels(user)
        if user.has_role? :mentor
          'mentors'
        else
          ''
        end
      end
    end
  end
end
