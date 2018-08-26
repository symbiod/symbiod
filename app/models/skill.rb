# frozen_string_literal: true

# This model contains a list of possible member skills
class Skill < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :user_skills
  has_many :users, through: :user_skills
  has_many :member_test_tasks, class_name: 'Member::TestTask'
  has_many :stack_skills
  has_many :stacks, through: :stack_skills

  include AASM

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
