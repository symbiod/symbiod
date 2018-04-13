require 'sorcery/model'

class User < ApplicationRecord
  rolify
  include AASM

  after_create :assign_default_role
  validates :email, presence: true, uniqueness: true
  has_many :ideas, foreign_key: 'author_id'
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

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

  def assign_default_role
    self.add_role(:developer) if self.roles.blank?
  end
end
