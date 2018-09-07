# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id                           :bigint(8)        not null, primary key
#  type                         :string
#  user_id                      :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  state                        :string
#  last_screening_followup_date :datetime
#

module Roles
  # Describes author role
  class Author < Role
    def self.sti_name
      'Roles::Author'
    end

    aasm column: 'state' do
      state :pending, initial: true
      state :policy_accepted, :active, :disabled, :rejected

      event :accept_policy do
        transitions from: :pending, to: :policy_accepted
      end

      event :activate do
        transitions from: %i[policy_accepted disabled], to: :active
      end

      event :reject do
        transitions from: :policy_accepted, to: :rejected
      end

      event :disable do
        transitions from: :active, to: :disabled
      end
    end
  end
end
