# frozen_string_literal: true

module Ops
  module Developer
    # Marks user as completed screening and notifies about new results
    class UncompletedUsers < BaseOperation
      success :screening_uncompleted_notification!

      private

      def screening_uncompleted_notification!(_ctx, user:, **)
        ::Developer::SendFollowupJob.perform_later(user.id)
        true
      end
    end
  end
end
