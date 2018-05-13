# frozen_string_literal: true

module Ops
  module Developer
    # When the candidate is disabled we run a bunch of tasks.
    # Usually it should happen when staff approves applicant's
    # test task during screening.
    class Disable < BaseOperation
      step :change_state!
      # step :send_notifications!
      # step :start_offboarding!

      private

      def change_state!(_ctx, user:, **)
        user.disable!
      end

      # def send_notifications!(_ctx, user:, **)
      # TODO: notify user about starting onboarding
      # by email
      # end
    end
  end
end
