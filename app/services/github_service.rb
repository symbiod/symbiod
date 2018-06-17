# frozen_string_literal: true

# The goal of this class is to automate github-related routine.
require 'octokit'

# Provides convenient interface for dealing with github api.
class GithubService
  attr_reader :token, :organization

  def initialize(token, organization)
    @token        = token
    @organization = organization
  end

  def create_repository(repo_name)
    client.create_repository(repo_name, new_repository_attributes)
  end

  def invite_member(user_id, team = 'bootcamp')
    username = user_name_by_id(user_id)
    client.update_organization_membership(organization, user: username)
    client.add_team_member(team, username)
  rescue Octokit::Forbidden => e
    ignore_exception?(e)
  end

  def search_users(query)
    client.search_users(query)
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
