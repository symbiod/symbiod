# frozen_string_literal: true

# It is a model of ideas that are offered by the authors
class Idea < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 500 }

  belongs_to :author, class_name: 'User'
  has_one :project

  scope :activated, -> { where(state: 'active') }

  include AASM

  aasm column: 'state' do
    state :pending, initial: true
    state :active, :disabled, :rejected

    event :activate do
      transitions from: %i[pending disabled], to: :active
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :disable do
      transitions from: :active, to: :disabled
    end
  end
end
