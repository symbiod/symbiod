# frozen_string_literal: true

module Ops
  module Member
    module Screening
      # This operation send message to Slack channel when member screening comleted
      class MessageToSlack < BaseOperation
        step :message_to_slack!

        private

        def message_to_slack!(_ctx, applicant:, **)
          SlackService
            .new(ENV['SLACK_TOKEN'], slack_config)
            .post_to_channel(slack_config.new_applications_channel, message_to_channel(applicant.id))
          true
        rescue SlackIntegration::FailedApiCallException => e
          handle_exception(e)
        end

        def handle_exception(exception)
          return true if exception.message == 'Unsuccessful send message: { "ok"=>false }'
          raise
        end

        def message_to_channel(applicant_id)
          <<-MESSAGE.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip
            <!here> New member screening comleted.
            You can make a review of the applicant by clicking on the link:
            #{Rails.application.routes.url_helpers.dashboard_test_task_assignment_url(id: applicant_id)}
          MESSAGE
        end
      end
    end
  end
end
