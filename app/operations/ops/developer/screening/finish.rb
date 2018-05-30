# frozen_string_literal: true

module Ops
  module Developer
    module Screening
      # Marks user as completed screening and notifies staff about new results
      class Finish < BaseOperation
        step :all_tasks_completed?
        success :complete_screening!
        success :screening_completed_notification_to_staff!
        success :screening_completed_notification_to_mentor!

        private

        def all_tasks_completed?(_ctx, user:, **)
          user.test_tasks_completed?
        end

        def complete_screening!(_ctx, user:, **)
          user.complete_screening!
        end

        def screening_completed_notification_to_staff!(_ctx, user:, **)
          Staff::ScreeningCompletedMailer.notify(user.id).deliver_later
        end

        def screening_completed_notification_to_mentor!(_ctx, user:, **)
          Mentor::ScreeningCompletedMailer.notify(user.id).deliver_later
        end
      end
    end
  end
end
