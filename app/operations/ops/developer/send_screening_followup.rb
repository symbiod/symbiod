# frozen_string_literal: true

module Ops
  module Developer
    # Marks user as completed screening and notifies about new results
    class SendScreeningFollowup < BaseOperation
      step :screening_uncompleted_notification!
      step :update_user_last_screening_followup_date!

      private

      def screening_uncompleted_notification!(_ctx, user:, **)
        @mail = ::Developer::Screening::SendFollowupMailer.notify(user.id).deliver_later
      end

      def update_user_last_screening_followup_date!(_ctx, user:, **)
        user.update(last_screening_followup_date: Time.now)
      end
    end
  end
end
