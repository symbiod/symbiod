# frozen_string_literal: true

module Projects
  # Runs create channel slack for project in asyncronous manner.
  class CreateSlackChannelJob < ApplicationJob
    queue_as :default

    def perform(project_id)
      project = Project.find(project_id)
      Ops::Projects::GenerateProjectSlackChannel.call(project: project)
    end
  end
end
