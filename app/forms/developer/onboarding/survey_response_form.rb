# frozen_string_literal: true

module Developer
  class Onboarding
    # Provides validations for survey responses
    class SurveyResponseForm < ::BaseForm
      property :user_id

      validation do
        required(:user_id).filled
        required(:feedback).filled
      end

      # This dinamic defined attributes forms based feedback questions
      # https://github.com/trailblazer/reform/wiki/How-do-I...%3F
      def initialize(*args)
        super(*args)
        class << self
          Developer::Onboarding::FeedbackQuestion.all.pluck(:key_name).map(&:to_sym).each do |key|
            property key
            validation do
              required(key).filled
            end
          end
        end
      end
    end
  end
end
