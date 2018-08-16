# frozen_string_literal: true

module Ops
  module Developer
    # Marks user as completed screening and notifies about new results
    class UncompletedUsers < BaseOperation
      step :screening_uncompleted_notification!

      private

      def screening_uncompleted_notification!(_ctx, user:, **)
        ::Developer::SendFollowupMailer.notify(user.id).deliver_later
      end
    end
  end
end
