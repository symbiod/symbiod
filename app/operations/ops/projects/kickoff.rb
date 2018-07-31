# frozen_string_literal: true

module Ops
  module Projects
    # This is the operation of creating a project from the idea
    class Kickoff < BaseOperation
      step :activate_idea!
      step :create_project!
      step :add_users_to_project!

      private

      def activate_idea!(_ctx, idea:, **)
        Ops::Idea::Activate.call(idea: idea)
      end

      def create_project!(_ctx, idea:, **)
        Project.create!(
          name: idea.name,
          slug: idea.name.downcase.tr(' ', '_'),
          stack_id: Stack.find_by(identifier: 'rails_monolith').id,
          idea_id: idea.id
        )
      end

      def add_users_to_project!(_ctx, idea:, **)
        idea.votes.up.each do |vote|
          idea.project.users << vote.user
        end
      end
    end
  end
end
