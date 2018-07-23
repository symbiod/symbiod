# frozen_string_literal: true

module Ops
  module Idea
    # This is the operation of creating a vote for the idea
    class Downvote < Ops::Idea::Vote
      private

      def vote_action
        'down'
      end
    end
  end
end
