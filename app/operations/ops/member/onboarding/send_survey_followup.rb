# frozen_string_literal: true

module Ops
  module Member
    class Onboarding
      # Send follow up about unfinished onboarding survey
      class SendSurveyFollowup < BaseOperation
        step :survey_uncompleted_notification!

        private

        def survey_uncompleted_notification!(_ctx, **)
          users = ::Onboarding::UsersInvitedAndFinishedSurveyQuery.new.call

          users.each do |user|
            ::Member::UnfinishedSurveyMailer.notify(user.id).deliver_later
            Role.where(user_id: user.id).set_last_unfinished_survey_followup_date
          end
        end
      end
    end
  end
end
