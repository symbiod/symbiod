# frozen_string_literal: true

module Ops
  module Developer
    # When the candidate is disabled we run a bunch of tasks,
    # including email notification
    class Disable < BaseOperation
      step :change_state!
      step :send_notifications!
      # step :start_offboarding!

      private

      def change_state!(_ctx, user:, **)
        user.disable!
      end

      def send_notifications!(_ctx, user:, **)
        ::Developer::DisabledNotificationMailer.notify(user.id).deliver_later
      end
    end
  end
end
