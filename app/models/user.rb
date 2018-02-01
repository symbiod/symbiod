class User < ApplicationRecord
  include AASM

  ROLES = %w[ developer stuff author ]

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: User::ROLES }

  has_many :ideas, foreign_key: 'author_id'

  aasm column: 'state' do
    state :pending, initial: true
    state :active, :disabled, :rejected

    event :activate do
      transitions from: [:pending, :disabled], to: :active
    end

    event :disable do
      transitions from: :active, to: :disabled
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end
  end

  authenticates_with_sorcery!
end
