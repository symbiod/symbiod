# frozen_string_literal: true

module Ops
  module Developer
    class Onboarding
      # Creating feedback and send email to staff and mentors
      class SubmitSurveyResponse < BaseOperation
        step Model(::Developer::Onboarding::SurveyResponse, :new)
        step Contract::Build(constant: ::Developer::Onboarding::SurveyResponseForm)
        step Contract::Validate()
        step Contract::Persist()
        success :survey_response_completed_notification!

        private

        def survey_response_completed_notification!(_ctx, model:, **)
          Staff::SurveyResponseCompletedMailer.notify(model.user.id).deliver_later
        end
      end
    end
  end
end
