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

      def try_to_create_project!(_ctx, idea:, **)
        Ops::Idea::Activate.call(idea: idea) if idea.votes.up.count >= COUNT_VOTES_KICKOFF_PROJECT
      end
    end
  end
end
