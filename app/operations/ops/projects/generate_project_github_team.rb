# frozen_string_literal: true

module Ops
  module Projects
    # This operation creates github team for project
    class GenerateProjectGithubTeam < BaseProjectGenerationOperation
      step :create_team!
      step :add_members_to_team!

      private

      def create_team!(_ctx, project:, **)
        GithubService
          .new(github_config.api_token, github_config.organization)
          .create_team(project.name, privacy(project))
        true
      end

      def add_members_to_team!(_ctx, project:, **)
        members_project(project).each do |member|
          GithubService
            .new(github_config.api_token, github_config.organization)
            .add_user_to_team(project.name, member.github)
        end
        true
      end

      def github_config
        Settings.github
      end

      def privacy(project)
        project.idea.private_project ? 'secret' : 'closed'
      end
    end
  end
end
