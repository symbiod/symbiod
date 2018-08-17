# frozen_string_literal: true

module Developer
  class Onboarding
    # This model feedback users
    class SurveyResponse < ApplicationRecord
      serialize :feedback, SurveyResponseSerializer
      store_accessor :feedback, :question_1, :question_2

      belongs_to :user
    end
  end
end
