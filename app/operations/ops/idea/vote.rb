# frozen_string_literal: true

module Ops
  module Idea
    # This is the operation of creating a vote for the idea
    class Vote < BaseOperation
      step :create_vote!

      private

      def create_vote!(_ctx, idea:, user:, vote_type:, **)
        ::Vote.create!(vote_type: vote_type, user: user, idea: idea)
      end
    end
  end
end
