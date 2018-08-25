# frozen_string_literal: true

module Roles
  # Describes member role
  class Member < Role
    def self.sti_name
      'Roles::Member'
    end

    has_one :survey_response,
            class_name: 'Member::Onboarding::SurveyResponse',
            foreign_key: 'role_id',
            dependent: :destroy

    aasm column: 'state' do
      state :pending, initial: true
      state :profile_completed, :policy_accepted, :screening_completed, :active,
            :disabled, :rejected

      event :complete_profile do
        transitions from: :pending, to: :profile_completed
      end

      event :accept_policy do
        transitions from: :profile_completed, to: :policy_accepted
      end

      event :complete_screening do
        transitions from: :policy_accepted, to: :screening_completed
      end

      event :activate do
        transitions from: %i[screening_completed disabled], to: :active
      end

      event :disable do
        transitions from: :active, to: :disabled
      end

      event :reject do
        transitions from: :screening_completed, to: :rejected
      end
    end
  end
end
