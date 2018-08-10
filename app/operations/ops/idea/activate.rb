# frozen_string_literal: true

module Ops
  module Idea
    # Operation activate idea
    class Activate < BaseOperation
      step :change_state!
      step :create_project!

      private

      def change_state!(_ctx, idea:, **)
        idea.activate!
      end

      def create_project!(_ctx, idea:, **)
        Ops::Projects::Kickoff.call(idea: idea)
      end
    end
  end
end
