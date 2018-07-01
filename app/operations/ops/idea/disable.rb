# frozen_string_literal: true

module Ops
  module Idea
    # Operation disable idea
    class Disable < BaseOperation
      step :change_state!

      private

      def change_state!(_ctx, idea:, **)
        idea.disable!
      end
    end
  end
end
