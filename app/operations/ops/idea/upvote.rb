# frozen_string_literal: true

module Ops
  module Idea
    # This is the operation of creating a vote for the idea
    class Upvote < Ops::Idea::Vote
      COUNT_VOTES_KICKOFF_PROJECT = 5

      step :try_to_create_project!

      private

      def vote_action
        'up'
      end

      def try_to_create_project!(options, idea:, **)
        return if can_kickoff_project?(idea)
        Ops::Idea::Activate.call(idea: idea)
        options['project'] = idea.project
      end

      def can_kickoff_project?(idea)
        idea.votes.up.count < COUNT_VOTES_KICKOFF_PROJECT
      end
    end
  end
end
