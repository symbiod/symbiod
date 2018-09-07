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
