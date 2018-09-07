# frozen_string_literal: true

# == Schema Information
#
# Table name: member_onboarding_survey_responses
#
#  id         :bigint(8)        not null, primary key
#  feedback   :jsonb            not null
#  role_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Member
  class Onboarding
    # This model feedback users
    class SurveyResponse < ApplicationRecord
      serialize :feedback, SurveyResponseSerializer

      # This method dynamically defines access attributes based on
      # feedback questions each time when the object is initialized
      def initialize(attributes)
        class << self
          Member::Onboarding::FeedbackQuestion.all.each do |question|
            store_accessor :feedback, question.key_name.to_sym
            validates question.key_name.to_sym, presence: true
          end
        end
        super(attributes)
      end

      belongs_to :role
      has_one :newcomer, through: :role, source: :user
    end
  end
end
