# frozen_string_literal: true

module Web
  module Idea
    # Runs send message to slack channel ideas when created new idea.
    class SlackMessageJob < ApplicationJob
      queue_as :default

      def perform(idea_id)
        Ops::Idea::MessageToSlack.call(
          channel: 'ideas',
          message: <<-MESSAGE.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip
                     New idea was added:
                     #{Rails.application.routes.url_helpers.dashboard_idea_url(id: idea_id)}
									 MESSAGE
        )
      end
    end
  end
end
