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
      end

      def invite_members!(_ctx, project:, **)
        members_slack_channel(project).each do |user|
          SlackService.new(ENV['SLACK_TOKEN']).invite_to_channel(project.slug, user.email)
        end
      end

      def members_slack_channel(project)
        project.users + [project.author, User.joins(:roles).where(roles: { type: 'Roles::Mentor' }).sample]
      end
    end
  end
end
