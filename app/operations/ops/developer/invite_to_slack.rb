# Handles all business logic regarding adding new member to slack.
# Besides calling public API, it also markes onboarding step as completed.
module Ops
  module Developer
    class InviteToSlack < BaseOperation
      step :add_to_slack!
      step :mark_step_as_complete!

      def add_to_slack!(ctx, user:, **)
        # TODO: where can we get a name of user at this step?
        SlackService.new(ENV['SLACK_TOKEN']).invite(user.email, '', '')
        true
      rescue SlackIntegration::FailedApiCallException => e
        return true if e == 'Unsuccessful invite api call: {"ok"=>false, "error"=>"already_invited"}'
      end

      def mark_step_as_complete!
        # TODO: should be implemented later
         true
      end
    end
  end
end

