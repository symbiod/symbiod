# frozen_string_literal: true

require 'uri'
require 'open-uri'
require 'json'
require './app/services/slack_integration/failed_api_call_exception'

module SlackIntegration
  # This class does not use any 3rd-party gems for Slack integration.
  # The reason is that user invite API endpoint is claimed to be `unofficial`
  # and most of the client libraries may not support it.
  # According to the article https://ruby.unicorn.tv/screencasts/automatically-send-slack-invitations
  class InviteUser
    def initialize(user:, channels:, token:)
      # TODO: receive channels list too
      @user      = user
      @channels  = channels
      @token     = token
    end

    def call
      response = JSON.parse(open(url).read)
      raise_error(response) unless successful_call?(response)
    end

    private

    def url
      "https://slack.com/api/users.admin.invite?#{URI.encode_www_form(
        [
          %W[channels #{@channels}], %w[set_active true], %w[_attempts 1], %W[token #{@token}],
          %W[email #{@user.email}], %W[first_name #{@user.first_name}], %W[last_name #{@user.last_name}]
        ]
      )}"
    end

    def successful_call?(response)
      return true if response['ok']
      return true if response['error'] == 'already_in_team'
      false
    end

    def raise_error(response)
      raise SlackIntegration::FailedApiCallException, "Unsuccessful invite api call: #{response}"
    end
  end
end
