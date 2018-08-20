# frozen_string_literal: true

module Developer
  class Onboarding
    # This model feedback users
    class SurveyResponse < ApplicationRecord
      serialize :feedback, SurveyResponseSerializer

      # This method dynamically defines access attributes based on
      # feedback questions each time when the object is initialized
      def initialize(attributes)
        class << self
          Developer::Onboarding::FeedbackQuestion.all.each do |question|
            store_accessor :feedback, question.key_name.to_sym
            validates question.key_name.to_sym, presence: true
          end
        end
        super(attributes)
      end

      belongs_to :user
    end
  end
end
