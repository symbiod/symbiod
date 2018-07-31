# frozen_string_literal: true

module Ops
  module Idea
    # This is the operation of creating a vote for the idea
    class Upvote < Ops::Idea::Vote
      step :check_possibiility_creating_project!

      private

      def vote_action
        'up'
      end

      def check_possibiility_creating_project!(_ctx, idea:, **)
        Ops::Projects::Kickoff.call(idea: idea) if idea.votes.up.count >= Project::COUNT_VOTES_KICKOFF_PROJECT
      end
    end
  end
end
