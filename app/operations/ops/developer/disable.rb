# frozen_string_literal: true

module Ops
  module Developer
    # When the candidate is disabled we run a bunch of tasks,
    # including email notification
    class Disable < ::Ops::Developer::BaseOperation
      step :change_state!
      step :send_notifications!

      private

      # TODO: we should pass here a role object, instead of user
      # in this case we'll not need to find the role each time.
      def change_state!(_ctx, user:, **)
        role(user).disable!
      end

      def send_notifications!(_ctx, user:, **)
        ::Developer::DisabledNotificationMailer.notify(user.id).deliver_later
      end
    end
  end
end
