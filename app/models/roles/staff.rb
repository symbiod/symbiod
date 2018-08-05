# frozen_string_literal: true

module Roles
  # Describes staff role
  class Staff < Role
    def self.sti_name
      'Roles::Staff'
    end

    aasm column: 'state' do
      state :active, initial: true
      state :disabled

      event :activate do
        transitions from: :disabled, to: :active
      end

      event :disable do
        transitions from: :active, to: :disabled
      end
    end
  end
end
