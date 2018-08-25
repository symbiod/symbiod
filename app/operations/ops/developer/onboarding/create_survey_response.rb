# frozen_string_literal: true

module Ops
  module Developer
    class Onboarding
      # This operation create feedback an mark step to onboarding
      class CreateSurveyResponse < BaseOperation
        step Model(::Developer::Onboarding::SurveyResponse, :new)
        step :create_survey_response!
        success :send_notify_to_staff!
        success :mark_feedback_completed!

        private

        def create_survey_response!(_ctx, model:, params:, **)
          model.attributes = params
          model.save
        end

        def send_notify_to_staff!(_ctx, user:, **)
          Staff::SurveyResponseCompletedMailer.notify(user.id).deliver_later
        end

        def mark_feedback_completed!(_ctx, user:, **)
          user.developer_onboarding.feedback_complete!
        end
      end
    end
  end
end
