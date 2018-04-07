require 'uri'
require 'open-uri'
require 'json'

module SlackIntegration
  class InviteUser
    def initialize(email, first_name, last_name)
      # TODO: receive role to choose which channels should be joined
      @email      = email
      @first_name = first_name
      @last_name  = last_name
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
      "&token=#{token}" +
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

    def token
      ENV['SLACK_TOKEN']
    end
  end
end
