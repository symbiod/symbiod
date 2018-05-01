# frozen_string_literal: true

module Ops
  module Developer
    # Just changes state to rejected and sends notification
    # to the reject candidate.
    class Reject < BaseOperation
      step :change_state!
      step :persist_feedback!
      step :notify_candidate!

      private

      def change_state!(_ctx, user:, **)
        user.reject!
      end

      def persist_feedback!(_ctx, user:, feedback:, **)
        assignment = user.test_task_assignments.last
        assignment.update!(feedback: feedback)
      end

      def notify_candidate!(_ctx, user:, feedback:, **)
        # TODO: send feedback to user
      end
    end
  end
end
