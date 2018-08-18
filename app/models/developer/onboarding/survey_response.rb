# frozen_string_literal: true

module Developer
  class Onboarding
    # This model feedback users
    class SurveyResponse < ApplicationRecord
      serialize :feedback, SurveyResponseSerializer
      after_initialize :setup_attributes

      belongs_to :user

      private

      # This method dynamically defines access attributes based on
      # feedback questions each time when the object is initialized
      def setup_attributes
        class << self
          Developer::Onboarding::FeedbackQuestion.all.each do |question|
            store_accessor :feedback, question.key_name.to_sym
          end
        end
      end
    end
  end
end
