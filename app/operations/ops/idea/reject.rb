# frozen_string_literal: true

module Ops
  module Idea
    # Operation reject idea
    class Reject < BaseOperation
      step :change_state!

      private

      def change_state!(_ctx, idea:, **)
        idea.reject!
      end
    end
  end
end
