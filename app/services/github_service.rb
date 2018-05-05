# frozen_string_literal: true

# The goal of this class is to automate github-related routine.
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

  # :nocov:
  def client
    @client ||= Octokit::Client.new(access_token: token)
  end
  # :nocov:
end
