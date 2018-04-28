# frozen_string_literal: true

class GithubService
  attr_reader :token, :organization

  def initialize(token, organization)
    @token        = token
    @organization = organization
  end

  def create_repository(repo_name)
    client.create_repository(repo_name, new_repository_attributes)
  end

  private

  def new_repository_attributes
    {
      organization: organization
    }
  end

  def client
    @client ||= Octokit::Client.new(access_token: token)
  end
end
