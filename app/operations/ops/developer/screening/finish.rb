# frozen_string_literal: true

module Ops
  module Developer
    module Screening
      # Marks user as completed screening and notifies about new results
      class Finish < BaseOperation
        step :all_tasks_completed?
        success :complete_screening!
        success :screening_completed_notification!
        success :screening_completed_message_to_slack!

        private

        # TODO: rework by passing role instead of user
        def all_tasks_completed?(_ctx, user:, **)
          user.test_tasks_completed?
        end

        def complete_screening!(_ctx, user:, **)
          role(user).complete_screening!
        end

        def screening_completed_notification!(_ctx, user:, **)
          Staff::ScreeningCompletedMailer.notify(user.id).deliver_later
        end

        def screening_completed_message_to_slack!(_ctx, user:, **)
          ::Developer::Screening::MessageToSlackJob.perform_later(user.id)
        end
      end
    end
  end
end
