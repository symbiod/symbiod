# frozen_string_literal: true

module Ops
  module Projects
    # This is the operation of creating a project channel to slack
    class GenerateProjectSlackChannel < BaseOperation
      step :create_slack_channel!
      step :invite_members!

      private

      def create_slack_channel!(_ctx, project:, **)
        SlackService.new(ENV['SLACK_TOKEN']).create_channel(project.slug)
        true
      end

      def invite_members!(_ctx, project:, **)
        members_slack_channel(project).each do |user|
          SlackService.new(ENV['SLACK_TOKEN']).invite_to_channel(project.slug, user.email)
        end
        true
      end

      def members_slack_channel(project)
        (project.users + [project.author, any_mentor]).compact
      end

      def any_mentor
        User.with_role(:mentor).sample
      end
    end
  end
end
