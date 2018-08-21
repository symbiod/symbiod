# frozen_string_literal: true

module Ideas
  # Runs send message to slack channel ideas when created new idea.
  class MessageToSlackJob < ApplicationJob
    queue_as :default

    def perform(idea_id)
      idea = ::Idea.find(idea_id)
      Ops::Idea::MessageToSlack.call(idea: idea)
    end
  end
end
