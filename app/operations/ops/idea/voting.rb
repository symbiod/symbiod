# frozen_string_literal: true

module Ops
  module Idea
    # Operation activate idea
    class Voting < BaseOperation
      step :change_state!

      private

      def change_state!(_ctx, idea:, **)
        idea.voting!
      end
    end
  end
end
