# frozen_string_literal: true

module Ops
  module Idea
    # This is the operation of creating a vote for the idea
    class Upvote < Ops::Idea::Vote
      private

      def vote_action
        'up'
      end
    end
  end
end
