# frozen_string_literal: true

# This class implements all required interaction with Slack service
# Some methods are used during new member onboarding, others are required
# for new project kick-off.
class SlackService
  def initialize(token, slack_config = {})
    @token = token
    @slack_config = slack_config
  end

  # We invite new registred member to our Slack
  def invite(user, channels)
    SlackIntegration::InviteUser.new(
      user:      user,
      channels:  id_channels(channels),
      token:     token
    ).call
  end

  # When the new idea is submitted we notify members through Slack
  def post_to_channel(channel, message)
    client.chat_postMessage(channel: channel, text: message, as_user: false, username: @slack_config.bot_name)
  end

  # At the moment of new project kick-off we invite all interested members to its channel
  def invite_to_channel(channel_name, email)
    user = user_by_email(email)
    raise SlackIntegration::FailedApiCallException, "User with email '#{email}' was not found" unless user
    channel = channel_by_name(channel_name)
    raise SlackIntegration::FailedApiCallException, "Channel with name '#{channel}' was not found" unless channel
    client.conversations_invite(channel: channel['id'], users: user['id'])
  rescue Slack::Web::Api::Errors::SlackError => e
    handle_exception(e)
  end

  # For each new project we create a separate channel
  def create_channel(channel_name)
    client.conversations_create(name: channel_name, is_private: false)
  end

  def team_member?(email)
    all_emails_team.include?(email)
  end

  private

  attr_reader :token
  # :nocov:
  def client
    @client ||= ::Slack::Web::Client.new(token: token)
  end
  # :nocov:

  def all_emails_team
    client.users_list[:members].map { |user| user[:profile][:email] }.compact
  end

  def channel_by_name(channel)
    client.conversations_list['channels'].find do |entry|
      entry['name'] == channel
    end
  end

  def user_by_email(email)
    client.users_list['members'].find do |entry|
      entry['profile']['email'] == email
    end
  end

  def id_channels(channels)
    channels.map { |channel| channel_by_name(channel)['id'] }.join(',')
  end

  def handle_exception(exception)
    return true if exception.message == 'cant_invite_self'
    raise
  end
end
