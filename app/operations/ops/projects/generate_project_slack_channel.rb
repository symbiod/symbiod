# frozen_string_literal: true

module Ops
  module Projects
    # This is the operation of creating a project channel to slack
    class GenerateProjectSlackChannel < BaseProjectGenerationOperation
      step :create_slack_channel!
      step :invite_members!

      private

      def create_slack_channel!(_ctx, project:, **)
        SlackService.new(ENV['SLACK_TOKEN']).create_channel(project.slug)
        true
      end

      def invite_members!(_ctx, project:, **)
        members_project(project).each do |user|
          SlackService.new(ENV['SLACK_TOKEN']).invite_to_channel(project.slug, user.email)
        end
        true
      end
    end
  end
end
