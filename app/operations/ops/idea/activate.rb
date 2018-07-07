# frozen_string_literal: true

module Ops
  module Idea
    # Operation activate idea
    class Activate < BaseOperation
      step :change_state!

      private

      def change_state!(_ctx, idea:, **)
        idea.activate!
      end
    end
  end
end
