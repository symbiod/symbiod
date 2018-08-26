# frozen_string_literal: true

# It is a model of ideas that are offered by the authors
class Idea < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 500 }

  belongs_to :author, class_name: 'User'
  has_one :project

  has_many :votes

  include AASM

  aasm column: 'state' do
    state :idea_pending, initial: true
    state :voting, :active, :disabled, :rejected

    event :voting do
      transitions from: :idea_pending, to: :voting
    end

    event :activate do
      transitions from: %i[voting disabled], to: :active
    end

    event :reject do
      transitions from: %i[pending voting], to: :rejected
    end

    event :disable do
      transitions from: :active, to: :disabled
    end
  end
end
