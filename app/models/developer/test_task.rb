# frozen_string_literal: true

module Developer
  # Represents the task description, that should be solved by developer
  class TestTask < ApplicationRecord
    include AASM

    validates :title, presence: true
    validates :position, presence: true
    validates :description, presence: true, length: { minimum: 50 }
    has_many :test_task_assignments, class_name: 'Developer::TestTaskAssignment', foreign_key: 'test_task_id'

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
