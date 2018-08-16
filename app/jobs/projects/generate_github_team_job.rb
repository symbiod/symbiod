# frozen_string_literal: true

module Projects
  # Runs create github team for project in asyncronous manner.
  class GenerateGithubTeamJob < ApplicationJob
    queue_as :default

    def perform(project_id)
      project = Project.find(project_id)
      Ops::Projects::GenerateProjectGithubTeam.call(project: project)
    end
  end
end
