# frozen_string_literal: true

require 'octokit'

# Provides convenient interface for dealing with github api.
# We should not do any intraction with github bypassing this object.
class GithubService
  attr_reader :token, :organization

  # TODO: probably it makes sense to inject Settings object?
  def initialize(token, organization)
    @token        = token
    @organization = organization
  end

  # Creates repository
  # @param repo_name String
  def create_repository(repo_name)
    client.create_repository(repo_name, new_repository_attributes)
  end

  # Add existing organization member to the existing team
  # @param team String the name of the team
  # @param username String canonic github username
  def add_user_to_team(team, username)
    client.add_team_member(team, username)
  end

  # Sends invite to join the existing organization
  # And also adds the user as a member of the default team
  # @param github_uid String numeric id of the user in github
  # @param team String the name of the default team for newcomer
  def invite_member(github_uid, default_team)
    username = user_name_by_id(github_uid)
    client.update_organization_membership(organization, user: username)
    add_user_to_team(default_team, username)
  rescue Octokit::Forbidden => e
    ignore_exception?(e)
  end

  # Resolves the github username by uid.
  # By default OAuth returns uid instead of username.
  # TODO: double check and prove that.
  def username_by_email(email)
    request = client.search_users(email)
    if (request[:total_count]).zero?
      raise GithubIntegration::UsernameResolveException, "User with email '#{email}' was not found"
    end
    request[:items].first[:login]
  end

  private

  def user_name_by_id(id)
    client.user(id.to_i)[:login]
  end

  def new_repository_attributes
    {
      organization: organization
    }
  end

  def ignore_exception?(exception)
    raise unless exception.message.include?('You cannot demote yourself')
    true
  end

  # :nocov:
  def client
    @client ||= Octokit::Client.new(access_token: token)
  end
  # :nocov:
end
