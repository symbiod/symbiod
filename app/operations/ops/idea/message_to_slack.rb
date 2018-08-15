# frozen_string_literal: true

module Ops
  module Idea
    # This operation send message to Slack channel
    class MessageToSlack < BaseOperation
      step :message_to_slack!

      private

      def message_to_slack!(_ctx, idea:, **)
        SlackService
          .new(ENV['SLACK_TOKEN'])
          .post_to_channel(slack_config.channel_ideas, message_to_channel(idea.id))
        true
      rescue SlackIntegration::FailedApiCallException => e
        handle_exception(e)
      end

      def handle_exception(exception)
        return true if exception.message == 'Unsuccessful send message: { "ok"=>false }'
        raise
      end

      def message_to_channel(idea_id)
        <<-MESSAGE.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip
          <!here> New idea was added:
          #{Rails.application.routes.url_helpers.dashboard_idea_url(id: idea_id)}
        MESSAGE
      end
    end
  end
end
