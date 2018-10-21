# frozen_string_literal: true

module Ops
  module Member
    class Onboarding
      # Send follow up about unfinished onboarding survey
      class SendSurveyFollowup < BaseOperation
        step :survey_uncompleted_notification!

        private

        def survey_uncompleted_notification!(_ctx, **)
          roles = ::Onboarding::UsersInvitedAndUnfinishedSurveyQuery.new.call

          roles.each do |role|
            ::Member::UnfinishedSurveyMailer.notify(role.id).deliver_later
            role.set_last_unfinished_survey_followup_date
            role.increase_survey_followup_counter
          end
        end
      end
    end
  end
end
