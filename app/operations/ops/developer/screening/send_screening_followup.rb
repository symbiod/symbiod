# frozen_string_literal: true

module Ops
  module Developer
    module Screening
      # Marks user as completed screening and notifies about new results
      class SendScreeningFollowup < BaseOperation
        step :screening_uncompleted_notification!
        step :update_user_last_screening_followup_date!

        private

        def screening_uncompleted_notification!(_ctx, user:, **)
          ::Developer::Screening::SendFollowupMailer.notify(user.id).deliver_later
        end

        def update_user_last_screening_followup_date!(_ctx, user:, **)
          user.set_last_screening_followup_date
        end
      end
    end
  end
end
