# frozen_string_literal: true

module GithubIntegration
  # This exception is raised, when we try to find github team_id by its name
  class NoTeamFoundException < StandardError; end
end
