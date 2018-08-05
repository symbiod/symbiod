# frozen_string_literal: true

module Roles
  # Describes developer role
  class Developer < Role
    def self.sti_name
      'Roles::Developer'
    end

    aasm column: 'state' do
      state :pending, initial: true
      state :policy_accepted, :profile_completed, :screening_completed, :active,
            :disabled, :rejected

      event :accept_policy do
        transitions from: :pending, to: :policy_accepted
      end

      event :complete_profile do
        transitions from: :policy_accepted, to: :profile_completed
      end

      event :complete_screening do
        transitions from: :profile_completed, to: :screening_completed
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
