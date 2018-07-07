# frozen_string_literal: true

module Ops
  module Idea
    # This operation send message to Slack channel
    class MessageToSlack < BaseOperation
      step :message_to_slack!

      def message_to_slack!(_ctx, model:, channel:, **)
        message = <<-MESSAGE.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip
                       New idea was added:
                       #{Rails.application.routes.url_helpers.dashboard_idea_url(id: model.id)}
                     MESSAGE
        SlackService.new(ENV['SLACK_TOKEN']).post_to_channel(channel, message)
        true
      rescue SlackIntegration::FailedApiCallException => e
        handle_exception(e)
      end

      def handle_exception(exception)
        return true if exception.message == 'Unsuccessful send message: { "ok"=>false }'
        raise
      end
    end
  end
end
