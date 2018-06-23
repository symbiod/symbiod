# frozen_string_literal: true

module Developer
  # Represents the task description, that should be solved by developer
  class TestTask < ApplicationRecord
    # TODO: delete after deploy
    self.ignored_columns = %w[role_id]

    include AASM

    validates :title, :position, :skill_id, presence: true
    validates :description, presence: true, length: { minimum: 50 }

    has_many :test_task_assignments, class_name: 'Developer::TestTaskAssignment', foreign_key: 'test_task_id'
    belongs_to :skill
    belongs_to :role, primary_key: :name, foreign_key: 'role_name'

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
