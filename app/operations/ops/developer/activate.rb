# frozen_string_literal: true

module Ops
  module Developer
    # When the candidate is approved we run a bunch of tasks.
    # Usually it should happen when staff approves applicant's
    # test task during screening.
    class Activate < BaseOperation
      step :change_state!
      step :send_notifications!
      step :start_onboarding!

      private

      def change_state!(_ctx, user:, **)
        user.activate!
      end

      def send_notifications!(_ctx, user:, **)
        true
        # TODO: notify user about starting onboarding
        # by email
      end

      def start_onboarding!(_ctx, user:, **)
        Ops::Developer::Onboarding.call(user: user)
      end
    end
  end
end
