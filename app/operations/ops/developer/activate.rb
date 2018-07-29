# frozen_string_literal: true

module Ops
  module Developer
    # When the candidate is approved we run a bunch of tasks.
    # Usually it should happen when staff approves applicant's
    # test task during screening.
    class Activate < ::Ops::Developer::BaseOperation
      step :change_state!
      step :set_approver!
      step :send_notifications!
      step :start_onboarding!

      private

      # TODO: rework by passing role instead of user
      def change_state!(_ctx, user:, **)
        role(user).activate!
      end

      def set_approver!(_ctx, user:, performer:, **)
        user.update!(approver_id: performer)
      end

      def send_notifications!(_ctx, user:, **)
        ::Developer::OnboardingStartedMailer.notify(user.id).deliver_later
      end

      def start_onboarding!(_ctx, user:, **)
        Ops::Developer::Onboarding.call(user: user)
      end
    end
  end
end
