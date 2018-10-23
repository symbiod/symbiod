# frozen_string_literal: true

module Ops
  module Member
    class Onboarding
      # Send follow up about unfinished onboarding survey
      class SendSurveyFollowup < BaseOperation
        step :survey_uncompleted_notification!

        private

        def survey_uncompleted_notification!(_ctx, role:, **)
          ::Member::UnfinishedSurveyMailer.notify(role.id).deliver_later
          role.touch(:last_not_finished_survey_followup_date_at)
          role.increment!(:unfinished_survey_followup_counter)
        end
      end
    end
  end
end
