# frozen_string_literal: true

module Developer
  class Onboarding
    # This model is questions feedbacks
    class FeedbackQuestion < ApplicationRecord
      before_validation :fill_key_name

      validates :description, presence: true
      validates :key_name, presence: true, uniqueness: true

      private

      def fill_key_name
        self.key_name = key_name.parameterize(separator: '_')
      end
    end
  end
end
