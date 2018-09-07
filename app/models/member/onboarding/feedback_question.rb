# frozen_string_literal: true

# == Schema Information
#
# Table name: member_onboarding_feedback_questions
#
#  id          :bigint(8)        not null, primary key
#  description :string           not null
#  key_name    :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Member
  class Onboarding
    # This model is questions feedbacks
    class FeedbackQuestion < ApplicationRecord
      before_validation :fill_key_name

      validates :description, presence: true
      validates :key_name, presence: true, uniqueness: true

      private

      # Used &, because validation in specs falling
      def fill_key_name
        self.key_name = key_name&.parameterize(separator: '_')
      end
    end
  end
end
