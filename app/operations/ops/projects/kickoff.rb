# frozen_string_literal: true

module Ops
  module Projects
    # This is the operation of creating a project from the idea
    class Kickoff < BaseOperation
      step :create_project!
      step :add_users_to_project!
      step :generate_project_slack_channel!

      private

      def create_project!(_ctx, idea:, **)
        Project.create!(
          name: idea.name,
          slug: idea.name.parameterize(separator: '_'),
          stack_id: Stack.find_by(identifier: 'rails_monolith').id,
          idea_id: idea.id
        )
      end

      def add_users_to_project!(_ctx, idea:, **)
        idea.votes.up.each do |vote|
          idea.project.users << vote.user
        end
      end

      def generate_project_slack_channel!(_ctx, idea:, **)
        ::Projects::CreateSlackChannelJob.perform_later(idea.project.id)
        true
      end
    end
  end
end
