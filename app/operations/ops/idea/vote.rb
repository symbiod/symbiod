# frozen_string_literal: true

module Ops
  module Idea
    # This is the operation of creating a vote for the idea
    class Vote < BaseOperation
      step :create_vote!

      private

      def create_vote!(_ctx, idea:, user:, **)
        ::Vote.create!(vote_type: vote_action, user: user, idea: idea)
      end
    end
  end
end
