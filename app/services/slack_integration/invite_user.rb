# This class does not use any 3rd-party gems for Slack integration.
# The reason is that user invite API endpoint is claimed to be `unofficial`
# and most of the client libraries may not support it.
# According to the article https://ruby.unicorn.tv/screencasts/automatically-send-slack-invitations
require 'uri'
require 'open-uri'
require 'json'
require './app/services/slack_integration/failed_api_call_exception'

module SlackIntegration
  class InviteUser
    def initialize(email:, first_name:, last_name:, token:)
      # TODO: receive channels list too
      @email      = email
      @first_name = first_name
      @last_name  = last_name
      @token      = token
    end

    def call
      response = JSON.parse(open(url).read)
      raise_error(response) unless response['ok']
    end

    private

    def url
      "https://slack.com/api/users.admin.invite" +
      "?channels=#{channels}" +
      "&set_active=true" +
      "&_attempts=1" +
      "&token=#{@token}" +
      "&email=#{URI::escape(@email)}" +
      "&first_name=#{URI::escape(@first_name)}" +
      "&last_name=#{URI::escape(@last_name)}"
    end

    def raise_error(response)
      fail SlackIntegration::FailedApiCallException, "Unsuccessful invite api call: #{response.to_s}"
    end

    def channels
      ''
    end
  end
end
