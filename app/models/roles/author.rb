# frozen_string_literal: true

module Roles
  # Describes author role
  class Author < Role
    def self.sti_name
      'Roles::Author'
    end

    aasm column: 'state' do
      state :pending, initial: true
      state :policy_accepted, :profile_completed, :active,
            :disabled, :rejected

      event :accept_policy do
        transitions from: :pending, to: :policy_accepted
      end

      event :complete_profile do
        transitions from: :policy_accepted, to: :profile_completed
      end

      event :activate do
        transitions from: %i[profile_completed disabled], to: :active
      end

      event :disable do
        transitions from: :active, to: :disabled
      end

      event :reject do
        transitions from: :profile_completed, to: :rejected
      end
    end
  end
end
