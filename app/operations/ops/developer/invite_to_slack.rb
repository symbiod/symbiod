# frozen_string_literal: true

module Ops
  module Developer
    # Handles all business logic regarding adding new member to Slack.
    # Besides calling public API, it also markes onboarding step as completed.
    class InviteToSlack < BaseOperation
      SLACK_CHANNELS = %w[bootcamp self-development feed ideas].freeze
      SLACK_CHANNEL_MENTOR = ['mentors'].freeze

      step :add_to_slack!

      def add_to_slack!(_ctx, user:, **)
        # TODO: where can we get a name of user at this step?
        SlackService.new(ENV['SLACK_TOKEN']).invite(user, channels(user))
        true
      rescue SlackIntegration::FailedApiCallException => e
        handle_exception(e)
      end

      def handle_exception(exception)
        return true if exception.message == 'Unsuccessful invite api call: {"ok"=>false, "error"=>"already_invited"}'
        raise
      end

      private

      def channels(user)
        if SlackPolicy.new(user, nil).able_to_join_channel?(:mentor)
          SLACK_CHANNELS + SLACK_CHANNEL_MENTOR
        else
          SLACK_CHANNELS
        end
      end
    end
  end
end
