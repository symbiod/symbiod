# frozen_string_literal: true

module Ops
  module Projects
    # This operation creates github team for project
    class GenerateProjectGithubTeam < BaseProjectGenerationOperation
      success :create_repo!
      success :create_team!
      success :add_members_to_team!

      private

      def create_repo!(_ctx, project:, **)
        return if project.idea.skip_bootstrapping
        GithubService
          .new(github_config.api_token, github_config.organization)
          .create_repository(project.slug)
      end

      def create_team!(_ctx, project:, **)
        GithubService
          .new(github_config.api_token, github_config.organization)
          .create_team(project.name, privacy(project), repo_names(project))
      end

      def add_members_to_team!(_ctx, project:, **)
        members_project(project).each do |member|
          GithubService
            .new(github_config.api_token, github_config.organization)
            .add_user_to_team(project.name, member.github)
        end
      end

      def privacy(project)
        project.idea.private_project ? 'secret' : 'closed'
      end

      def repo_names(project)
        project.idea.skip_bootstrapping ? [] : ["#{github_config.organization}/#{project.slug}"]
      end
    end
  end
end
