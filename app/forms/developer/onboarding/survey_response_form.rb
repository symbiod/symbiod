# frozen_string_literal: true

module Developer
  class Onboarding
    # Provides validations for survey responses
    class SurveyResponseForm < ::BaseForm
      property :question_1
      property :question_2
      property :user_id

      validation do
        required(:question_1).filled
        required(:question_2).filled
        required(:user_id).filled
      end
    end
  end
end
