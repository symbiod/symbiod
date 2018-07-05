# frozen_string_literal: true

# Runs send message to slack channel ideas when created new idea.
class SlackMessageJob < ApplicationJob
  queue_as :default

  def perform(model, channel)
    Ops::Idea::MessageToSlack.call(model: model, channel: channel)
  end
end
