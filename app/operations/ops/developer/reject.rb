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

      # TODO: rework with passing the role
      def change_state!(_ctx, user:, **)
        role(user).reject!
      end

      def persist_feedback!(_ctx, user:, feedback:, **)
        assignment = user.test_task_assignments.last
        assignment.update!(feedback: feedback)
      end

      def notify_candidate!(_ctx, user:, feedback:, **)
        ::Developer::RejectionNotificationMailer.notify(user.id, feedback).deliver_later
      end
    end
  end
end
